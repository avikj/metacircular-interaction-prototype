"""Expose the seam between fixed scheduling and rolling center reuse."""


def fixed_level_centers(modulus: int, prefix: int, scale: int, p: int):
    return [modulus - prefix - d * scale for d in range(p - 1)]


def seam_jump(modulus: int, prefix: int, scale: int, p: int, digit: int) -> int:
    centers = fixed_level_centers(modulus, prefix, scale, p)
    next_center = modulus - (prefix + digit * scale)
    return next_center - centers[-1]

