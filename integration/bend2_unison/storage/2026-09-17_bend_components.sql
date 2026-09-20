-- Native Bend components have distinct bytes and member roles from Unison terms/types.
-- Presentations are per codebase owner: the canonical component hash is shared,
-- while authored source/path attachments may differ between users.
ALTER TYPE entity_kind ADD VALUE IF NOT EXISTS 'bend_component';

CREATE TABLE bend_components (
  component_hash_id INTEGER PRIMARY KEY REFERENCES component_hashes(id) ON DELETE CASCADE,
  component_bytes BYTEA NOT NULL
);

CREATE TABLE sandboxed_bend_components (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  component_hash_id INTEGER NOT NULL REFERENCES bend_components(component_hash_id) ON DELETE CASCADE,
  entity_bytes BYTEA NOT NULL,
  PRIMARY KEY (user_id, component_hash_id)
);

CREATE TABLE bend_component_dependencies (
  component_hash_id INTEGER NOT NULL REFERENCES bend_components(component_hash_id) ON DELETE CASCADE,
  member_index BIGINT NOT NULL CHECK (member_index >= 0),
  dependency_component_hash_id INTEGER NOT NULL REFERENCES component_hashes(id),
  dependency_member_index BIGINT NOT NULL CHECK (dependency_member_index >= 0),
  PRIMARY KEY (component_hash_id, member_index, dependency_component_hash_id, dependency_member_index)
);
CREATE INDEX bend_component_dependencies_by_target
  ON bend_component_dependencies (dependency_component_hash_id);

CREATE TABLE bend_component_presentations (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  component_hash_id INTEGER NOT NULL REFERENCES bend_components(component_hash_id) ON DELETE CASCADE,
  member_index BIGINT NOT NULL CHECK (member_index >= 0),
  source_digest BYTEA NOT NULL,
  source_utf8 BYTEA NOT NULL,
  source_start_byte BIGINT NOT NULL CHECK (source_start_byte >= 0),
  source_end_byte BIGINT NOT NULL CHECK (source_end_byte >= source_start_byte),
  authored_name TEXT NOT NULL,
  source_path TEXT NOT NULL,
  PRIMARY KEY (user_id, component_hash_id, member_index, source_digest,
    source_start_byte, source_end_byte, authored_name, source_path)
);

CREATE OR REPLACE FUNCTION have_hash_in_codebase(codebase_owner_user_id UUID, hash_to_check TEXT)
RETURNS BOOLEAN STABLE PARALLEL SAFE AS $$
BEGIN
  RETURN EXISTS (
    SELECT FROM causals causal JOIN causal_ownership co ON causal.id = co.causal_id
      WHERE co.user_id = codebase_owner_user_id AND causal.hash = hash_to_check
    UNION ALL
    SELECT FROM namespace_ownership no JOIN branch_hashes bh ON no.namespace_hash_id = bh.id
      WHERE no.user_id = codebase_owner_user_id AND bh.base32 = hash_to_check
    UNION ALL
    SELECT FROM patch_ownership po JOIN patches p ON po.patch_id = p.id
      WHERE po.user_id = codebase_owner_user_id AND p.hash = hash_to_check
    UNION ALL
    SELECT FROM sandboxed_terms st JOIN terms t ON st.term_id = t.id
      JOIN component_hashes ch ON t.component_hash_id = ch.id
      WHERE st.user_id = codebase_owner_user_id AND ch.base32 = hash_to_check
    UNION ALL
    SELECT FROM sandboxed_types st JOIN types t ON st.type_id = t.id
      JOIN component_hashes ch ON t.component_hash_id = ch.id
      WHERE st.user_id = codebase_owner_user_id AND ch.base32 = hash_to_check
    UNION ALL
    SELECT FROM sandboxed_bend_components sb JOIN component_hashes ch ON sb.component_hash_id = ch.id
      WHERE sb.user_id = codebase_owner_user_id AND ch.base32 = hash_to_check
  );
END;
$$ LANGUAGE plpgsql;

-- Native namespace bindings retain the same derived hash/member identity as
-- the client's branch format. A member may have both a term and a HIT role.
CREATE TABLE bend_component_members (
  component_hash_id INTEGER NOT NULL REFERENCES bend_components(component_hash_id) ON DELETE CASCADE,
  member_index BIGINT NOT NULL CHECK (member_index >= 0),
  has_term BOOLEAN NOT NULL,
  has_type BOOLEAN NOT NULL,
  CHECK (has_term OR has_type),
  PRIMARY KEY (component_hash_id, member_index)
);

ALTER TABLE namespace_terms
  ADD COLUMN bend_component_hash_id INTEGER,
  ADD COLUMN bend_member_index BIGINT;
ALTER TABLE namespace_terms DROP CONSTRAINT namespace_terms_check;
ALTER TABLE namespace_terms ADD CONSTRAINT namespace_terms_reference_check
  CHECK (
    num_nonnulls(builtin_id, term_id, constructor_id, bend_component_hash_id) = 1
    AND ((bend_component_hash_id IS NULL) = (bend_member_index IS NULL))
  );
ALTER TABLE namespace_terms ADD CONSTRAINT namespace_terms_bend_member_fk
  FOREIGN KEY (bend_component_hash_id, bend_member_index)
  REFERENCES bend_component_members(component_hash_id, member_index);
DROP INDEX namespace_terms_by_name_and_ref;
CREATE UNIQUE INDEX namespace_terms_by_name_and_ref
  ON namespace_terms(namespace_hash_id, name_segment_id, builtin_id, term_id,
                     constructor_id, bend_component_hash_id, bend_member_index)
  NULLS NOT DISTINCT;

ALTER TABLE namespace_types
  ADD COLUMN bend_component_hash_id INTEGER,
  ADD COLUMN bend_member_index BIGINT;
ALTER TABLE namespace_types DROP CONSTRAINT namespace_types_check;
ALTER TABLE namespace_types ADD CONSTRAINT namespace_types_reference_check
  CHECK (
    num_nonnulls(builtin_id, type_id, bend_component_hash_id) = 1
    AND ((bend_component_hash_id IS NULL) = (bend_member_index IS NULL))
  );
ALTER TABLE namespace_types ADD CONSTRAINT namespace_types_bend_member_fk
  FOREIGN KEY (bend_component_hash_id, bend_member_index)
  REFERENCES bend_component_members(component_hash_id, member_index);
DROP INDEX namespace_types_by_name_and_ref;
CREATE UNIQUE INDEX namespace_types_by_name_and_ref
  ON namespace_types(namespace_hash_id, name_segment_id, builtin_id, type_id,
                     bend_component_hash_id, bend_member_index)
  NULLS NOT DISTINCT;

-- Follow the same causal ancestors and child namespaces as Share's ordinary
-- component dependency walker, then traverse native Bend member edges.
CREATE FUNCTION bend_components_reachable_from_causals(the_causal_ids INTEGER[])
RETURNS TABLE(component_hash_id INTEGER) AS $$
  WITH RECURSIVE reachable_causals(causal_id, namespace_hash_id) AS (
    SELECT c.id, c.namespace_hash_id
    FROM UNNEST(the_causal_ids) AS roots(root_id)
      JOIN causals c ON c.id = roots.root_id
    UNION
    (WITH current_causals AS (
      SELECT causal_id, namespace_hash_id FROM reachable_causals
    )
      SELECT ancestor.id, ancestor.namespace_hash_id
      FROM current_causals cc
        JOIN causal_ancestors ca ON ca.causal_id = cc.causal_id
        JOIN causals ancestor ON ancestor.id = ca.ancestor_id
      UNION
      SELECT child.id, child.namespace_hash_id
      FROM current_causals cc
        JOIN namespace_children nc ON nc.parent_namespace_hash_id = cc.namespace_hash_id
        JOIN causals child ON child.id = nc.child_causal_id
    )
  ), reachable_components(component_hash_id) AS (
    SELECT nt.bend_component_hash_id
    FROM reachable_causals rc
      JOIN namespace_terms nt ON nt.namespace_hash_id = rc.namespace_hash_id
    WHERE nt.bend_component_hash_id IS NOT NULL
    UNION
    SELECT nt.bend_component_hash_id
    FROM reachable_causals rc
      JOIN namespace_types nt ON nt.namespace_hash_id = rc.namespace_hash_id
    WHERE nt.bend_component_hash_id IS NOT NULL
    UNION
    SELECT dep.dependency_component_hash_id
    FROM reachable_components current
      JOIN bend_component_dependencies dep ON dep.component_hash_id = current.component_hash_id
    WHERE dep.dependency_component_hash_id <> current.component_hash_id
  )
  SELECT DISTINCT component_hash_id FROM reachable_components;
$$ LANGUAGE SQL STABLE;

CREATE FUNCTION copy_bend_components_for_causal(the_causal_id INTEGER,
  from_codebase_user_id UUID, to_codebase_user_id UUID) RETURNS VOID AS $$
BEGIN
  INSERT INTO sandboxed_bend_components(user_id, component_hash_id, entity_bytes)
    SELECT to_codebase_user_id, reachable.component_hash_id, source.entity_bytes
    FROM bend_components_reachable_from_causals(ARRAY[the_causal_id]) reachable
      JOIN sandboxed_bend_components source
        ON source.component_hash_id = reachable.component_hash_id
       AND source.user_id = from_codebase_user_id
    ON CONFLICT DO NOTHING;
  INSERT INTO bend_component_presentations(user_id, component_hash_id, member_index,
    source_digest, source_utf8, source_start_byte, source_end_byte, authored_name, source_path)
    SELECT to_codebase_user_id, p.component_hash_id, p.member_index,
      p.source_digest, p.source_utf8, p.source_start_byte, p.source_end_byte,
      p.authored_name, p.source_path
    FROM bend_components_reachable_from_causals(ARRAY[the_causal_id]) reachable
      JOIN bend_component_presentations p
        ON p.component_hash_id = reachable.component_hash_id
       AND p.user_id = from_codebase_user_id
    ON CONFLICT DO NOTHING;
  INSERT INTO serialized_components(user_id, component_hash_id, bytes_id)
    SELECT to_codebase_user_id, reachable.component_hash_id, source.bytes_id
    FROM bend_components_reachable_from_causals(ARRAY[the_causal_id]) reachable
      JOIN serialized_components source
        ON source.component_hash_id = reachable.component_hash_id
       AND source.user_id = from_codebase_user_id
    ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql;

