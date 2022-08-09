ghostchan: ghost.o
	@ld ./build/ghost.o -o	./build/ghostchan
	@echo "compilation successful"
ghost.o: cliOverlay/libs/macros.asm
	@mkdir -p "build"
	@nasm -f elf64 ./cliOverlay/main.asm -o ./build/ghost.o
clean:
	@rm ./build/*
