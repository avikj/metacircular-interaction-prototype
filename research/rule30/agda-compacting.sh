#!/bin/sh
# agda under a heap cap (compacting near the cap), for the yantra kernel
GHCRTS="-M12500m" exec agda "$@"
