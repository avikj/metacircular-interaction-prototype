#!/usr/bin/env ruby
# Run a fresh UCM with a real SQLite codebase, then inspect checked Nat peers
# through its authenticated HTTP API. Set BEND_UCM and HVM4 for other builds.
require 'json'
require 'net/http'
require 'pty'
require 'socket'
require 'sqlite3'
require 'tmpdir'
require 'timeout'

root = File.expand_path('../../..', __dir__)
source = File.join(root, 'integration/bend2_unison/storage/fixtures/SemanticNat.bend')
binary = ENV.fetch('BEND_UCM') do
  Dir[File.join('/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4',
    '.stack-work/install/*/*/bin/unison')].first or abort 'set BEND_UCM'
end
server = TCPServer.new('127.0.0.1', 0)
port = server.addr[1]
server.close
token = 'bend-semantic-fixture'
base = "http://127.0.0.1:#{port}/#{token}"
alphabet = '0123456789abcdefghijklmnopqrstuv'

def fetch_json(url)
  uri = URI(url)
  warn "GET #{url}"
  response = Net::HTTP.start(uri.host, uri.port, nil, nil, nil, nil,
    open_timeout: 3, read_timeout: 3) { |http| http.get(uri.request_uri) }
  raise "HTTP #{response.code}: #{url}: #{response.body}" unless response.code == '200'
  JSON.parse(response.body)
end

Dir.mktmpdir('bend-semantic-http-') do |tmp|
  codebase = File.join(tmp, 'codebase')
  source_for_ucm = File.join(tmp, 'SemanticNat.bend')
  File.write(source_for_ucm, File.read(source).gsub(/\balias\b/, 'other'))
  env = {'TERM' => 'xterm-256color', 'PAGER' => 'cat',
         'UNISON_LSP_PORT' => (port + 1).to_s}
  reader, writer, pid = PTY.spawn(env, binary, '--codebase-create', codebase,
    '--token', token, '--port', port.to_s, '--no-file-watch')
  begin
    output = ''
    Timeout.timeout(35) do
      until output.include?('scratch') && output.include?('main')
        ready = IO.select([reader], nil, nil, 1)
        output << reader.read_nonblock(8192) if ready
      end
      sleep 0.3 # The line editor initializes just after printing its first prompt.
      writer.write("load #{source_for_ucm}\n")
      until output.include?('3 addressed names')
        ready = IO.select([reader], nil, nil, 1)
        output << reader.read_nonblock(8192) if ready
      end
    end
    warn 'UCM load completed'
    database = SQLite3::Database.new(File.join(codebase, '.unison/v2/unison.sqlite3'))
    rows = database.execute(<<~SQL)
      SELECT p.authored_name, p.component_index, h.base32
      FROM bend_presentation p
      JOIN object o ON o.id = p.component_object_id
      JOIN hash h ON h.id = o.primary_hash_id
      WHERE p.authored_name IN ('direct','beta','other')
    SQL
    warn "SQLite rows: #{rows.inspect}"
    refs = rows.to_h do |name, member, base32|
      bits = base32.chars.map { |char| alphabet.index(char).to_s(2).rjust(5, '0') }.join
      [name, [[bits[0, 512]].pack('B*').unpack1('H*'), member]]
    end
    raise "missing fixture refs: #{refs.inspect}" unless refs.keys.sort == %w[beta direct other]
    raise 'structural addresses collapsed' if refs['direct'] == refs['beta']
    refs.each do |name, (digest, member)|
      result = fetch_json("#{base}/api/bend/subterm?digest=#{digest}&member=#{member}&root=body")
      peers = result.fetch('semanticPeers').map { |peer| [peer.fetch('digest'), peer.fetch('member')] }
      expected = case name
                 when 'direct' then [refs.fetch('beta')]
                 when 'beta' then [refs.fetch('direct')]
                 else []
                 end
      raise "#{name} peers #{peers.inspect} != #{expected.inspect}" unless peers == expected
      raise "missing checked type for #{name}" unless result.dig('projection', 'type')
    end
    digest, member = refs.fetch('direct')
    uri = URI("#{base}/ui/bend/component/#{digest}/#{member}")
    page = Net::HTTP.start(uri.host, uri.port, nil, nil, nil, nil,
      open_timeout: 3, read_timeout: 3) { |http| http.get(uri.request_uri) }
    raise "browser HTTP #{page.code}" unless page.code == '200'
    raise 'browser has no semantic links' unless page.body.include?('Same checked Nat value')
    puts 'semantic Nat peers: native SQLite + authenticated HTTP + browser route passed'
  rescue => error
    warn "UCM output: #{output.inspect}"
    raise error
  ensure
    Process.kill('KILL', pid) rescue nil
    reader.close rescue nil
    writer.close rescue nil
  end
end
