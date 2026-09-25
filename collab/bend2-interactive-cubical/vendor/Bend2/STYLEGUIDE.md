Bend Style Guide
================

## Parsing

### Backtracking Minimization

Backtracking (`try`) should be avoided. As such, every parser starts with a
small `try` block, covering the minimal *discriminating prefix* for that
particular syntax. So, for example, to parse:

- Swi ::= `λ{0:zero;+:succ}`

- Mat ::= `λ{[]:nil;<>:cons}`

We write:

```haskell
parseSwiLam = do
  _ <- try $ do
    _ <- symbol "λ"
    _ <- symbol "{"
    _ <- symbol "0"
    _ <- symbol ":"
    return ()
  z <- parseTerm
  _ <- parseSemi
  _ <- symbol "+"
  _ <- symbol ":"
  s <- parseTerm
  _ <- parseSemi
  _ <- symbol "}"
  return (Swi z s)
```

And:

```haskell
parseMatLam = do
  _ <- try $ do
    _ <- symbol "λ"
    _ <- symbol "{"
    _ <- symbol "[]"
    _ <- symbol ":"
    return ()
  n <- parseTerm
  _ <- parseSemi
  _ <- symbol "<>"
  _ <- symbol ":"
  c <- parseTerm
  _ <- parseSemi
  _ <- symbol "}"
  return (Mat n c)
```

Notice how the *discriminating prefixes*, `λ{0:` and `λ{[]`, are wrapped in a
'try' block, while the rest of the parser isn't. This is intentional, as it
reduces backtracking, improves performance, and improves error messages. Every
parser must follow this convention. We should *never* call `try` elsewhere.
