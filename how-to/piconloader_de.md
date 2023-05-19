# *PiconLoader*

**Table of contents**
*   [Vorwort](#vorwort)
*   [Installation](#installation)
*   [Verwendung](#verwendung)

----

## Vorwort

Dieses Skript habe ich für meinen Kumpel geschrieben, da er mich fragte, ob es denn möglich sei dafür zu sorgen, dass das entsprechende Picon von Sendern zeitgesteuert angezeigt wird, falls sich dieses durch einen Senderwechsel ändert.

Das Skript wurde auf einem *Vu+ Duo2*-Receiver entwickelt, könnte jedoch auch auf verwandten Systemen laufen, aber das habe ich nicht getestet. Der Code dahinter ist nicht gerade der schönste, aber er funktioniert und kann logischerweise noch verbessert sowie erweitert werden.

Das *PiconLoader*-Projekt steht unter der [MIT-Lizenz](https://opensource.org/licenses/MIT). Diese kann auch der Datei `LICENSE` entnommen werden.

Die Installation und Konfiguration setzt grundlegende Erfahrung mit *Linux*, dessen Shell sowie dem *vi*-Editor (nicht *Vim*, nachdem dieser auf dem Gerät nicht verfügbar ist) um Dateien zu bearbeiten.

Wichtig ist, dass man sich dessen bewusst ist, dass das unsachgemäße Ausführen von Befehlen und die Anpassung bestimmter Dateien zu Datenverlust führen oder gar das System beschädigen kann. Von daher sollte man vorsichig vorgehen und verstehen, was man da eigentlich macht ("think before you type").

Für die Verbindung mittels SCP und SSH ist ein Benutzername und Kennwort erforderlich. Der Benutzername lautet `root` und das erforderliche Kennwort kann scheinbar mittels dem *Change Root Password* Plug-in des Receivers gesetzt werden oder vielleicht auch über einen anderen Weg.

Die entsprechenden Namen (die so genannten "Kanalreferenzen") für die jeweiligen Picons können mit dem Programm *dreamboxEDIT* ermittelt werden.

Fragen zum Receiver selbst oder zur *dreamboxEDIT*-Software kann ich nicht beantworten, da ich weder ein solches Gerät besitze noch diese Software selbst verwendet habe.

[Seitenanfang](#piconloader)

## Installation

### Archiv auf die Festplatte im Receiver kopieren

Zunächst muss Archiv, in dem sich der PiconLoader befindet, auf den Receiver kopiert werden.

Hier in der Anleitung wird das Archiv von Version 1.0.3 verwendet. Die Versionsnummer ist ein Teil des Dateinamens. Wird eine andere Version installiert muss der Dateiname in den Befehlen entsprechend angepasst werden.

#### Auf *Windows*-Systemen

Das Archiv kann mittels dem [hier](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) erhältlichen, kostenlosen und quelloffenen Tool *PSCP* (`pscp.exe`) auf den Receiver übertragen werden.

Wenn sich das Archiv im Verzeichnis `C:\vu` befindet und der Receiver die IP-Adresse `192.168.1.1` hat, würde der Befehl wie folgt aussehen:

```
pscp.exe -scp C:\vu\piconloader-1.0.3.tar root@192.168.1.1:/media/hdd/
```

Falls der Pfad Leerzeichen enthält muss dieser in Anführungszeichen (`"`) stehen:

```
pscp.exe -scp "C:\Users\John Doe\Downloads\piconloader-1.0.3.tar" root@192.168.1.1:/media/hdd/
```

#### Auf *Unix*-ähnlichen Systemen (*Linux*, *BSD*, *MacOSX*)

Diese Systeme stellen in der Regel bereits von Haus aus den `scp` Befehl für das Übertragen von Dateien bereit.

Wenn sich das Archiv im Verzeichnis `/home/user/Downloads` befindet und der Receiver die IP-Adresse `192.168.1.1` hat, würde der Befehl wie folgt aussehen:

```
scp /home/user/Downloads/piconloader-1.0.3.tar root@192.168.1.1:/media/hdd/
```

### Mittels SSH auf den Receiver verbinden

Nachdem das Archiv auf die Festplatte des Receivers kopiert wurde muss als nächstes eine SSH-Verbindung zum Gerät hergestellt werden.

#### Auf *Windows*-Systemen

Dies kann mit dem [hier](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) erhältlichen, kostenlosen und quelloffenen Tool *PuTTY* (`putty.exe`) durchgeführt werden.

Hierzu muss einfach der Verbindungs-Typ auf **SSH** gestellt, die IP-Adresse des Receivers angegeben und auf **Open** geklickt werden.

#### Auf *Unix*-ähnlichen Systemen (*Linux*, *BSD*, *MacOSX*)

Diese Systeme stellen in der Regel ebenfalls von Haus aus den `ssh` Befehl für den Zugriff via SSH bereit.

```
ssh root@192.168.1.1
```

### Archiv entpacken

Wenn dann die SSH-Verbindung steht, ist es notwendig, das Archiv auf der Festplatte des Receivers zu entpacken. Dazu muss zunächst in das entsprechende Verzeichnis gewechselt werden:

```
cd /media/hdd
```

Dort liegt das kopierte Archiv. Mit dem folgenden Befehl wird dieses entpackt.

```
tar xvf piconloader-1.0.3.tar
```

Danach existiert das Verzeichnis ```/media/hdd/piconloader```, welches die relevanten Dateien und leere Unterordner enthält.

Das Archiv selbst kann nun wieder gelöscht werden:

```
rm piconloader-1.0.3.tar
```

### Skript als ausführbar markieren

Damit das Skript auch ausgeführt werden kann ist es erforderlich, diesses als ausführbar zu markieren. Das sollte zwar schon der Fall sein, aber falls das aus unerfindlichen Gründen nicht mehr so ist, kann man dies wie folgt tun.

Wenn das Skript schon als ausführbar markiert ist und man dennoch den folgenden Befehl ausführt hat dies keinerlei Auswirkungen bzw. Folgen.

```
chmod +x ./piconloader/piconloader.sh
```

### Cronjob einrichten

Damit das Skript beim Starten des Receivers und auch zu den konfigurierten Zeiten die Picons tauscht, muss ein Cronjob eingerichtet werden.

Dazu muss die Datei `/etc/cron/crontab/root` editiert werden:

```
vi /etc/cron/crontabs/root
```

In dieser muss lediglich folgende Zeile eingefügt

```
* * * * * sh /media/hdd/piconloader/piconloader.sh
```

und dann die Datei gespeichert (sowie geschlossen) werden. Damit sollte der Cronjob direkt aktiv werden. Mittels dem Befehl

```
crontab /etc/cron/crontabs/root
```

kann dies auch manuell durchgeführt werden.

[Seitenanfang](#piconloader)

## Verwendung

Nehmen wir an, der Sender *BlahTV* läuft von 06:30 Uhr bis 20:00 Uhr und außerhalb dieser Zeit läuft *BlubbTV*.

Im ersten Schritt wird das Picon von *BlahTV* benötigt. Dies kann über *dreamboxEDIT* ermittelt werden, zum Beispiel:

```
1_0_1_9999_436_1_C0000X_0_0_0.png
```

Danach wird das Picon von *BlubbTV* benötigt. Diese Datei muss jedoch wie das Picon von *BlahTV* umbenannt und vorne mit einem Unterstrich (`_`) versehen werden:

```
_1_0_1_9999_436_1_C0000X_0_0_0.png
```
Somit sieht es wie folgt aus:

* `1_0_1_9999_436_1_C0000X_0_0_0.png`  (Picon von *BlahTV*)
* `_1_0_1_9999_436_1_C0000X_0_0_0.png` (Picon von *BlubbTV*)

Beide Picons müssen auf den Receiver in `/media/hdd/` kopiert werden (mittels `scp` oder `pscp.exe`).

Danach in der SSH-Sitzung auf den Receiver in das Verzeichnis von *PiconLoader* wechseln

```
cd /media/hdd/piconloader
```

und zwei neue Verzeichnisse im Unterverzeichnis `qhourly` erstellen. Bei Zeitangaben ist es erforderlich Bindestriche (`-`) statt wie üblich Doppelpunkte (`:`) als Trennzeichen zu verwenden, da Doppelpunkte bei *FAT32*- und *NTFS*-Dateisystemen nicht erlaubt sind.

```
mkdir -p ./qhourly/06-30
mkdir -p ./qhourly/20-00
```

Das Picon von *BlahTV* muss in das erste Verzeichnis verschoben werden:

```
mv /media/hdd/1_0_1_9999_436_1_C0000X_0_0_0.png ./qhourly/06-30
```

Danach dann das Picon from *BlubbTV* in das zweite Verzeichnis und so umbenannt werden, dass die Namen beider Picon-Dateien identisch sind. Dafür ist lediglich ein Befehl erforderlich:

```
mv /media/hdd/_1_0_1_9999_436_1_C0000X_0_0_0.png ./qhourly/20-00/1_0_1_9999_436_1_C0000X_0_0_0.png
```

Am Fernseher kann nun zur Sendernummer gewechselt werden, auf der beide Sender je nach Uhrzeit laufen. Falls dies bereits der Fall ist, muss für maximal eine Minute auf einen anderen Sender und wieder zurück geschaltet werden. Danach sollte sollte dann das entsprechende Picon angezeigt werden.

Um genau zu sein wird die Picon-Datei nach `/usr/share/enigma2/picon` kopiert (das Verzeichnis, in dem sich alle Picons befinden) und das bisherige überschrieben.

Der tägliche oder monatliche Austausch der Picons funktioniert genau so, mit dem Unterschied, dass die Verzeichnisnamen entsprechend anders lauten.

Um beispielsweise ein Picon am 3. Januar auszutauschen, muss die Picon-Datei in das Verzeichnis `./daily/01-03` kopiert werden.

Für einen monatlichen Austausch, beispielsweise Januar, lautet der Verzeichnisname `./monthly/01`.

[Seitenanfang](#piconloader)
