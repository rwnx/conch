# Conch Shell

A _conch_ shell. geddit? _conch_ **_shell_** 😅
```sh
🐚 > ls -lah
total 24
drwxr-xr-x   8 admin  staff   256B  8 Mar 20:48 .
drwxr-xr-x  51 admin  staff   1.6K  8 Mar 20:42 ..
🐚 > 
```

![Conch Shell](https://upload.wikimedia.org/wikipedia/commons/2/2b/Conch_drawing.jpg)

A (bad) shell, written in (good) zig.

## Getting started
```sh
zig build

zig build run

zig test **/*_test.zig
```


## Misc
```sh
docker run -v $PWD:/app euantorano/zig:latest run src/main.zig
```