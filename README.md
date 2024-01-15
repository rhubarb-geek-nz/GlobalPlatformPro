# GlobalPlatformPro
This project comes from [GlobalPlatformPro](https://github.com/martinpaljak/GlobalPlatformPro) and is used to manage JavaCards.
The default maven build creates a single JAR using the maven-shade-plugin, this new build leaves the source jar files intact and signed.

To build...
```
$ ./package.sh
...
ar: creating globalplatformpro_20.01.23_all.deb
```

The installed package is as follows

```
$ find /opt/GlobalPlatformPro/
/opt/GlobalPlatformPro/
/opt/GlobalPlatformPro/lib
/opt/GlobalPlatformPro/lib/jopt-simple-5.0.4.jar
/opt/GlobalPlatformPro/lib/ber-tlv-1.0-9.jar
/opt/GlobalPlatformPro/lib/slf4j-api-1.7.25.jar
/opt/GlobalPlatformPro/lib/httpclient-4.5.8.jar
/opt/GlobalPlatformPro/lib/apdu4j-core-19.05.08.jar
/opt/GlobalPlatformPro/lib/apdu4j-jnasmartcardio-0.2.7+190425.jar
/opt/GlobalPlatformPro/lib/apdu4j-pcsc-19.05.08.jar
/opt/GlobalPlatformPro/lib/commons-codec-1.11.jar
/opt/GlobalPlatformPro/lib/httpcore-4.4.11.jar
/opt/GlobalPlatformPro/lib/capfile-19.03.04.jar
/opt/GlobalPlatformPro/lib/jna-4.0.0.jar
/opt/GlobalPlatformPro/lib/globalplatformpro-20.01.23.jar
/opt/GlobalPlatformPro/lib/gptool-20.01.23.jar
/opt/GlobalPlatformPro/lib/gson-2.8.5.jar
/opt/GlobalPlatformPro/lib/bcpkix-jdk15on-1.62.jar
/opt/GlobalPlatformPro/lib/bcprov-jdk15on-1.62.jar
/opt/GlobalPlatformPro/lib/slf4j-simple-1.7.25.jar
/opt/GlobalPlatformPro/lib/commons-logging-1.2.jar
/opt/GlobalPlatformPro/bin
/opt/GlobalPlatformPro/bin/gp
```
