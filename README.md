A nice lil repo for playing around with cc65 and writing nes code in assembly and c.

# ASM

Hand crafted assembly :italianchefkissingfingers:

## Compilation

```
ca65 src/main.asm -I src/ -o main.o
ld65 main.o -C nes.cfg -o game.nes
```

# C

A heavier, slighyly easier to read version. I'll deal with this later.
