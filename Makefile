GNUSTEP_ENV = . /usr/share/GNUstep/Makefiles/GNUstep.sh

all:
	cd WeatherApp && $(GNUSTEP_ENV) && make CC=clang OBJCC=clang

clean:
	cd WeatherApp && $(GNUSTEP_ENV) && make clean

install: all
	cp WeatherApp/obj/weather /usr/local/bin/weather

.PHONY: all clean install
