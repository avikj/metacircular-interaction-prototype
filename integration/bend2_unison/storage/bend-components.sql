-- Native checked Bend2 objects. Object type 4 extends the stable enum.
-- Sync/temp-entity support is deliberately separate from this local schema.

INSERT INTO object_type_description (id, description)
VALUES (4, 'Bend2 Checked Component');

-- The object primary hash addresses the *checked structural component*.
-- The complete versioned AST, types, HIT declarations, and local reference
-- table live in object.bytes using the native Bend component codec.
-- It is never a hash of emitted HVM text.

-- Checker-established normal-form identity is an additional searchable fact.
-- It cannot be the sole address: different executable checked presentations
-- can have equal normal forms, while the object table permits one byte blob
-- for each primary hash. Absence of a row means no identity was established.
CREATE TABLE bend_semantic_identity (
  component_object_id INTEGER NOT NULL REFERENCES object(id),
  component_index INTEGER NOT NULL CHECK (component_index >= 0),
  semantics_version TEXT NOT NULL,
  normal_form_hash_id INTEGER NOT NULL REFERENCES hash(id),
  PRIMARY KEY (component_object_id, component_index, semantics_version)
);

CREATE INDEX bend_semantic_identity_by_normal_form
ON bend_semantic_identity (semantics_version, normal_form_hash_id);

-- Exact authored forms are retained independently of structural and semantic
-- identity. Several presentations may point at one checked member. The source
-- digest is of the complete UTF-8 bytes, with no formatting normalization.
-- Names and positions here are display/edit provenance, never component refs.
CREATE TABLE bend_presentation (
  id INTEGER PRIMARY KEY NOT NULL,
  component_object_id INTEGER NOT NULL REFERENCES object(id),
  component_index INTEGER NOT NULL CHECK (component_index >= 0),
  source_digest BLOB NOT NULL,
  source_utf8 BLOB NOT NULL,
  source_start_byte INTEGER NOT NULL CHECK (source_start_byte >= 0),
  source_end_byte INTEGER NOT NULL CHECK (source_end_byte >= source_start_byte),
  authored_name TEXT NOT NULL,
  source_path TEXT NOT NULL,
  UNIQUE (component_object_id, component_index, source_digest,
          source_start_byte, source_end_byte, authored_name, source_path)
);

CREATE INDEX bend_presentation_by_member
ON bend_presentation (component_object_id, component_index);
