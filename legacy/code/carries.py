import zlib, struct

def carries(m, n, p):
    "Kummer: number of carries adding m+n in base p = v_p(C(m+n,n))"
    c = 0; carry = 0
    while m or n:
        s = m % p + n % p + carry
        carry = 1 if s >= p else 0
        c += carry
        m //= p; n //= p
    return c

def png(path, w, h, rgb):
    raw = b''.join(b'\x00' + bytes(rgb[y*w*3:(y+1)*w*3]) for y in range(h))
    def chunk(t, d):
        c = struct.pack('>I', len(d)) + t + d
        return c + struct.pack('>I', zlib.crc32(t+d) & 0xffffffff)
    hdr = struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0)
    open(path,'wb').write(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR',hdr)
        + chunk(b'IDAT', zlib.compress(raw,9)) + chunk(b'IEND', b''))

# max carries possible tells us the palette range
for p in (2,3,5,7):
    N = 512
    mx = 0
    grid = []
    for m in range(N):
        row = []
        for n in range(N):
            k = carries(m,n,p); row.append(k); mx = max(mx,k)
        grid.append(row)
    print(f"base {p}: max carries in {N}x{N} = {mx}")

def ramp(k, mx):
    if k == 0: return (14, 16, 22)
    t = k/max(1,mx)
    # deep indigo -> teal -> amber -> pale gold
    stops = [(24,30,60),(20,86,110),(46,150,140),(214,158,64),(246,232,190)]
    x = t*(len(stops)-1); i = min(int(x), len(stops)-2); f = x-i
    a,b = stops[i], stops[i+1]
    return tuple(int(a[j]+(b[j]-a[j])*f) for j in range(3))

for p, N in ((2,1024),(3,972),(5,625),(7,686)):
    mx = 0; grid = []
    for m in range(N):
        row = [carries(m,n,p) for n in range(N)]
        mx = max(mx, max(row)); grid.append(row)
    buf = bytearray()
    for row in grid:
        for k in row: buf.extend(ramp(k,mx))
    png(f"carry_p{p}.png", N, N, buf)
    print(f"wrote carry_p{p}.png  {N}x{N}  max={mx}")
