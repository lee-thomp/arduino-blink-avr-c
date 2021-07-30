CC 			= avr-gcc
OBJCOPY 	= avr-objcopy

PROG	 	= blink
DEV			= atmega328p

FCPU		= 160000000
CFLAGS 		= -pipe -Os -ffunction-sections -fdata-sections -mmcu=${DEV}
PORT		= /dev/ttyACM0

${PROG}.hex : ${PROG}.elf
	${OBJCOPY} -O ihex -R .eeprom ${PROG}.elf ${PROG}.hex

${PROG}.elf : ${PROG}.o
	${CC} -Wl,--gc-sections ${CFLAGS} ${PROG}.o -o ${PROG}.elf
	
${PROG}.o : ${PROG}.c
	${CC} -c -std=gnu99 -DF_CPU=${FCPU} -Wall ${CFLAGS} ${PROG}.c -o ${PROG}.o	

install : ${PROG}.hex
	avrdude -F -V -c arduino -p ${DEV} -P ${PORT} -b 115200 -U flash:w:${PROG}.hex

clean : 
	rm -f ${PROG}.[abd-z]*
