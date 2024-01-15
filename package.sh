#!/bin/sh -ex
#
#  Copyright 2021, Roger Brown
#
#  This file is part of rhubarb pi.
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
# 
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# $Id: package.sh 35 2021-03-21 14:41:38Z rhubarb-geek-nz $
#

VERSION=20.01.23
GITTAG="v$VERSION"
GITHOME=https://github.com/martinpaljak/GlobalPlatformPro
NAME=gptool
PKGNAME=globalplatformpro
PROJECT="$NAME-$VERSION"
OPTNAME=GlobalPlatformPro
SYSTEM=$(uname -s)

cleanup()
{
	rm -rf tmp data control data.tar.gz control.tar.gz debian-binary GlobalPlatformPro rpms rpm.spec
}

first()
{
	echo "$1"
}

cleanup

trap cleanup 0

if test -z "$JAVA_HOME"
then
	for d in $( find /usr/lib/jvm -name javac -type f )
	do
		JAVA_HOME=$( dirname $d )
		JAVA_HOME=$( dirname $JAVA_HOME )
		break
	done
fi

test -x "$JAVA_HOME/bin/javac"

if test ! -d GlobalPlatformPro
then
	(
		set -ex

		git clone "$GITHOME.git" GlobalPlatformPro

		cd GlobalPlatformPro

		git checkout "$GITTAG"

		git apply - << 'EOF'
diff --git a/tool/pom.xml b/tool/pom.xml
index 9080307..85b8866 100644
--- a/tool/pom.xml
+++ b/tool/pom.xml
@@ -64,80 +64,42 @@
             <scope>test</scope>
         </dependency>
     </dependencies>
+    <properties>
+        <jar.finalName>${project.artifactId}-${project.version}</jar.finalName>
+    </properties>
     <build>
         <plugins>
             <plugin>
                 <groupId>org.apache.maven.plugins</groupId>
-                <artifactId>maven-shade-plugin</artifactId>
-                <version>3.2.1</version>
-                <executions>
-                    <execution>
-                        <phase>package</phase>
-                        <goals>
-                            <goal>shade</goal>
-                        </goals>
-                        <configuration>
-                            <finalName>gp</finalName>
-                            <transformers>
-                                <transformer
-                                        implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
-                                    <mainClass>pro.javacard.gp.GPTool</mainClass>
-                                </transformer>
-                            </transformers>
-                            <filters>
-                                <filter>
-                                    <artifact>*:*</artifact>
-                                    <excludes>
-                                        <exclude>META-INF/*.SF</exclude>
-                                        <exclude>META-INF/*.DSA</exclude>
-                                        <exclude>META-INF/*.RSA</exclude>
-                                        <exclude>META-INF/maven/**</exclude>
-                                    </excludes>
-                                </filter>
-                            </filters>
-                        </configuration>
-                    </execution>
-                </executions>
+                <artifactId>maven-jar-plugin</artifactId>
+                <version>2.4</version>
+                <configuration>
+                    <archive>
+                        <manifest>
+                            <addClasspath>true</addClasspath>
+                            <mainClass>pro.javacard.gp.GPTool</mainClass>
+                        </manifest>
+                    </archive>
+                </configuration>
             </plugin>
-            <!-- Package for Windows -->
             <plugin>
-                <groupId>com.akathist.maven.plugins.launch4j</groupId>
-                <artifactId>launch4j-maven-plugin</artifactId>
-                <version>1.7.25</version>
+                <groupId>org.apache.maven.plugins</groupId>
+                <artifactId>maven-assembly-plugin</artifactId>
                 <executions>
                     <execution>
-                        <id>gp-exe</id>
                         <phase>package</phase>
                         <goals>
-                            <goal>launch4j</goal>
+                            <goal>single</goal>
                         </goals>
                         <configuration>
-                            <headerType>console</headerType>
-                            <outfile>target/gp.exe</outfile>
-                            <jar>target/gp.jar</jar>
-                            <errTitle>GlobalPlatformPro</errTitle>
-                            <classPath>
-                                <mainClass>pro.javacard.gp.GPTool</mainClass>
-                            </classPath>
-                            <jre>
-                                <minVersion>1.8.0</minVersion>
-                            </jre>
-                            <versionInfo>
-                                <fileVersion>${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.incrementalVersion}.${parsedVersion.buildNumber}</fileVersion>
-                                <txtFileVersion>${project.version}</txtFileVersion>
-                                <fileDescription>GlobalPlatformPro</fileDescription>
-                                <copyright>(C) 2015 - 2019 Martin Paljak and contributors (LGPL+MIT)</copyright>
-                                <productVersion>${parsedVersion.majorVersion}.${parsedVersion.minorVersion}.${parsedVersion.incrementalVersion}.${parsedVersion.buildNumber}</productVersion>
-                                <txtProductVersion>${project.version}</txtProductVersion>
-                                <productName>GlobalPlatformPro</productName>
-                                <internalName>gppro</internalName>
-                                <originalFilename>gp.exe</originalFilename>
-                            </versionInfo>
+                            <appendAssemblyId>false</appendAssemblyId>
+                            <descriptors>
+                                <descriptor>src/main/assembly/zip.xml</descriptor>
+                            </descriptors>
                         </configuration>
                     </execution>
                 </executions>
             </plugin>
-
         </plugins>
     </build>
 </project>
\ No newline at end of file
diff --git a/tool/src/main/assembly/zip.xml b/tool/src/main/assembly/zip.xml
new file mode 100644
index 0000000..b52b3bb
--- /dev/null
+++ b/tool/src/main/assembly/zip.xml
@@ -0,0 +1,29 @@
+<assembly xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2"
+          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
+          xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2 http://maven.apache.org/xsd/assembly-1.1.2.xsd">
+    <id>zip</id>
+    <includeBaseDirectory>true</includeBaseDirectory>
+
+    <formats>
+        <format>zip</format>
+    </formats>
+    <fileSets>
+        <fileSet>
+            <directory>${project.basedir}/conf</directory>
+        </fileSet>
+    </fileSets>
+    <files>
+        <file>
+            <source> ${project.build.directory}/${jar.finalName}.jar</source>
+            <outputDirectory>lib</outputDirectory>
+        </file>
+    </files>
+    <dependencySets>
+        <dependencySet>
+            <outputDirectory>lib</outputDirectory>
+            <excludes>
+                <exclude>${project.groupId}:${project.artifactId}:jar:*</exclude>
+            </excludes>
+        </dependencySet>
+    </dependencySets>
+</assembly>
EOF

		JAVA_HOME="$JAVA_HOME" mvn clean package
	)
fi

case "$SYSTEM" in
	Darwin )
		DESTDIR=usr/local/$OPTNAME
		;;
	* )
		DESTDIR=opt/$OPTNAME
		;;
esac

mkdir -p "data/$DESTDIR/bin" control tmp

(
	set -ex

	cd tmp

	"$JAVA_HOME/bin/jar" xvf "../GlobalPlatformPro/tool/target/$PROJECT.zip"
)

mv "tmp/$PROJECT/lib" "data/$DESTDIR/lib"

if test -n "$JARSIGNER" && test -x "$JARSIGNER"
then
	"$JARSIGNER" "data/$DESTDIR/lib/gptool-$VERSION.jar" "data/$DESTDIR/lib/globalplatformpro-$VERSION.jar"
fi

cat > "data/$DESTDIR/bin/gp" << EOF
#!/bin/sh -e

if test -n "\$JAVA_HOME"
then
	JAVA="\$JAVA_HOME/bin/java"
else
	JAVA=java
fi

exec "\$JAVA" -jar "/$DESTDIR/lib/$PROJECT.jar" "\$@"
EOF

chmod ugo+x "data/$DESTDIR/bin/gp" 

case "$SYSTEM" in
	Linux )
		SIZE=`du -sk data`
		SIZE=`first $SIZE`

		cat >control/control <<EOF
Package: $PKGNAME
Version: $VERSION
Architecture: all
Maintainer: rhubarb-geek-nz@users.sourceforge.net
Section: misc
Priority: extra
Homepage: $GITHOME
Installed-Size: $SIZE
Description: GlobalPlatformPro
EOF

		cat control/control

		echo "2.0" >debian-binary

		for d in data control
		do
			(
				set -e
				cd $d
				tar --owner=0 --group=0 --create --gzip --file ../$d.tar.gz ./*
			)
		done

		ar r "$PKGNAME"_"$VERSION"_all.deb debian-binary control.tar.gz data.tar.gz

		if rpmbuild --version
		then
			cat > rpm.spec << EOF
Name: $PKGNAME
Version: $VERSION
Release: 1
BuildArch: noarch
License: LGPLv3+
Prefix: /$DESTDIR
Summary: GlobalPlatformPro
%description
Load and manage applets on compatible JavaCards from command line or from your Java project.

%files
%defattr(-,root,root)
/$DESTDIR
EOF

			PWD=`pwd`
			rpmbuild --buildroot "$PWD/data" --define "_rpmdir $PWD/rpms" --define "_build_id_links none" -bb "$PWD/rpm.spec"

			find rpms -name "*.rpm" | while read N
			do
				cp "$N" .
			done
		fi
		;;

	Darwin )
		pkgbuild --root data/$DESTDIR \
			--identifier nz.geek.rhubarb.$PKGNAME \
			--version "$VERSION" \
			--install-location "/$DESTDIR" \
			--sign "Developer ID Installer: $APPLE_DEVELOPER" \
			"$OPTNAME-$VERSION.pkg"
		;;
esac
