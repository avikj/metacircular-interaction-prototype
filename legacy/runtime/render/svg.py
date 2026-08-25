#!/usr/bin/env python3
"""A minimal, exact SVG writer.  Written by hand; no libraries, no floats.

SVG is text, so it is written as text.  Every coordinate, length and font size
is an **integer** -- the writer refuses anything else, which is the same
discipline the rest of the runtime applies to arithmetic: a picture whose
geometry is a float is a picture that renders differently on two machines, and
byte-identical output is a requirement here, not a nicety.

Determinism.  Attributes are emitted in a fixed order from an explicit list,
never from a dictionary iteration.  Element order is insertion order.  The
document is assembled with ``\\n`` newlines and written in binary, so the bytes
do not depend on the platform.

Colours are accepted as anything with a ``hex()`` method (`chroma.RGB`) or as a
string.  This module imports nothing -- not even from its own package -- so a
colour bug cannot hide behind a rendering bug.

Not implemented, deliberately: transforms, paths, gradients, opacity,
animation, CSS.  Every one of those would let a picture say something the
exact code did not compute.
"""

from __future__ import annotations

from typing import Optional, Sequence

XML_ESCAPES = (("&", "&amp;"), ("<", "&lt;"), (">", "&gt;"), ('"', "&quot;"), ("'", "&apos;"))
MONO = "monospace"


class SVGError(Exception):
    """Raised on a non-integer coordinate or an ill-formed colour."""


def escape(text: str) -> str:
    out = str(text)
    for needle, replacement in XML_ESCAPES:
        out = out.replace(needle, replacement)
    return out


def _int(name: str, value) -> int:
    if not isinstance(value, int) or isinstance(value, bool):
        raise SVGError("%s must be an int, got %r" % (name, value))
    return value


def _colour(value) -> str:
    if value is None:
        return "none"
    if isinstance(value, str):
        return value
    getter = getattr(value, "hex", None)
    if getter is None:
        raise SVGError("colour %r has no hex()" % (value,))
    return getter()


def _open_tag(name: str, attributes: Sequence) -> str:
    parts = ["<", name]
    for key, value in attributes:
        if value is None:
            continue
        parts.append(' %s="%s"' % (key, escape(value)))
    parts.append(">")
    return "".join(parts)


def _tag(name: str, attributes: Sequence, body: Optional[str] = None) -> str:
    parts = ["<", name]
    for key, value in attributes:
        if value is None:
            continue
        parts.append(' %s="%s"' % (key, escape(value)))
    if body is None:
        parts.append("/>")
    else:
        parts.append(">")
        parts.append(body)
        parts.append("</%s>" % (name,))
    return "".join(parts)


class SVG:
    """An SVG document under construction.  Integer geometry only."""

    def __init__(self, width: int, height: int, title: str, description: str = "", background=None) -> None:
        self.width = _int("width", width)
        self.height = _int("height", height)
        self.title = title
        self.description = description
        self._body: list = []
        self._depth = 0
        # The background is emitted at render time, not now: callers routinely
        # discover the final height only after laying the content out, and a
        # background captured at construction would be the wrong size.
        self.background = background

    # -- structure --------------------------------------------------------

    def _emit(self, markup: str) -> None:
        self._body.append(("  " * (self._depth + 1)) + markup)

    def open_group(self, identifier: Optional[str] = None) -> None:
        self._emit(_open_tag("g", (("id", identifier),)))
        self._depth += 1

    def close_group(self) -> None:
        if self._depth == 0:
            raise SVGError("close_group with no open group")
        self._depth -= 1
        self._emit("</g>")

    # -- primitives -------------------------------------------------------

    def rect(
        self,
        x: int,
        y: int,
        width: int,
        height: int,
        fill=None,
        stroke=None,
        stroke_width: int = 0,
        title: Optional[str] = None,
    ) -> None:
        attributes = (
            ("x", str(_int("x", x))),
            ("y", str(_int("y", y))),
            ("width", str(_int("width", width))),
            ("height", str(_int("height", height))),
            ("fill", _colour(fill)),
            ("stroke", _colour(stroke) if stroke is not None else None),
            ("stroke-width", str(_int("stroke_width", stroke_width)) if stroke is not None else None),
            ("shape-rendering", "crispEdges"),
        )
        if title is None:
            self._emit(_tag("rect", attributes))
        else:
            self._emit(_tag("rect", attributes, body=_tag("title", (), body=escape(title))))

    def line(self, x1: int, y1: int, x2: int, y2: int, stroke, stroke_width: int = 1) -> None:
        self._emit(
            _tag(
                "line",
                (
                    ("x1", str(_int("x1", x1))),
                    ("y1", str(_int("y1", y1))),
                    ("x2", str(_int("x2", x2))),
                    ("y2", str(_int("y2", y2))),
                    ("stroke", _colour(stroke)),
                    ("stroke-width", str(_int("stroke_width", stroke_width))),
                    ("shape-rendering", "crispEdges"),
                ),
            )
        )

    def circle(self, cx: int, cy: int, radius: int, fill=None, stroke=None, stroke_width: int = 0) -> None:
        self._emit(
            _tag(
                "circle",
                (
                    ("cx", str(_int("cx", cx))),
                    ("cy", str(_int("cy", cy))),
                    ("r", str(_int("radius", radius))),
                    ("fill", _colour(fill)),
                    ("stroke", _colour(stroke) if stroke is not None else None),
                    ("stroke-width", str(_int("stroke_width", stroke_width)) if stroke is not None else None),
                ),
            )
        )

    def text(
        self,
        x: int,
        y: int,
        content: str,
        fill,
        size: int = 12,
        anchor: str = "start",
        weight: str = "normal",
        family: str = MONO,
    ) -> None:
        if anchor not in ("start", "middle", "end"):
            raise SVGError("bad text anchor %r" % (anchor,))
        self._emit(
            _tag(
                "text",
                (
                    ("x", str(_int("x", x))),
                    ("y", str(_int("y", y))),
                    ("fill", _colour(fill)),
                    ("font-family", family),
                    ("font-size", str(_int("size", size))),
                    ("font-weight", weight),
                    ("text-anchor", anchor),
                    ("xml:space", "preserve"),
                ),
                body=escape(content),
            )
        )

    # -- output -----------------------------------------------------------

    def render(self) -> str:
        if self._depth != 0:
            raise SVGError("%d group(s) left open" % (self._depth,))
        head = _open_tag(
            "svg",
            (
                ("xmlns", "http://www.w3.org/2000/svg"),
                ("width", str(self.width)),
                ("height", str(self.height)),
                ("viewBox", "0 0 %d %d" % (self.width, self.height)),
                ("version", "1.1"),
            ),
        )
        lines = ['<?xml version="1.0" encoding="UTF-8"?>', head]
        lines.append("  " + _tag("title", (), body=escape(self.title)))
        if self.description:
            lines.append("  " + _tag("desc", (), body=escape(self.description)))
        if self.background is not None:
            lines.append(
                "  "
                + _tag(
                    "rect",
                    (
                        ("x", "0"),
                        ("y", "0"),
                        ("width", str(self.width)),
                        ("height", str(self.height)),
                        ("fill", _colour(self.background)),
                        ("shape-rendering", "crispEdges"),
                    ),
                )
            )
        lines.extend(self._body)
        lines.append("</svg>")
        return "\n".join(lines) + "\n"

    def write(self, path: str) -> int:
        payload = self.render().encode("utf-8")
        with open(path, "wb") as handle:
            handle.write(payload)
        return len(payload)


__all__ = ["MONO", "SVG", "SVGError", "escape"]
