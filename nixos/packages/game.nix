{ pkgs }:
(with pkgs;
  [
    (retroarch.withCores
      (cores: with cores; [ snes9x fceumm mgba stella pcsx-rearmed ]))
  ])
