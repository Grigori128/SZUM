# SZUM

## Opis projektu

Temat projektu: Sterowanie torsem i głową robota humanoidalnego

Sterowanie jakobianowe zostało napisane w programie Matlab i zawiera się w 3 plikach funkcyjnych: "RobotMotion.m", "kin.m", "invkin.m".
Funkcja "kin.m" rozwiązuje zadanie proste kinematyki, tj. na podstawie położeń kątowych wyznacza położenia wszystkich punktów w układzie kartezjańskim.
Funkcja "invkin.m" rozwiązuje zadanie odwrotne kinematyki, tj. na podstawie zadanej prędkości końcówki roboczej wyznacza prędkości kątowe poszczególnych członów.
Funkcja "RobotMotion.m", na podstawie wybranej sekwencji, realizuje sterowanie robota według zadanej trajektorii, wykorzystując powyższe funkcje.

W celu spełnienia wymogu automatycznego uruchomienia symulacji, napisano skrypt konfiguracyjny środowiska Gazebo "gazebo_setup.sh", a także skrypt pod Matlaba "matlabbash.sh", umożliwiający wybór sekwencji.

Dodatkowo zamieszczono plik skryptowy "turtlectrl.m", pozwalalący na sterowanie żółwiem w ROS-ie, z wykorzystaniem metody Lapunowa. Plik ten NIE jest wykorzystywany w głównym projekcie.

## Instrukcja uruchomienia

UWAGA! Do poprawnego działania poniższego programu wymagane są: 

1. Zainstalowany i skonfigurowany Matlab w dowolnej wersji wraz z toolboxami "ROStoolbox" oraz "Robotics System Toolbox".

2. Zainstalowany oraz poprawnie skonfigurowany ROS oraz Gazebo.

3. Python w wersji 2.7.15+.

Aby poprawnie uruchomić symulację robota w programie Gazebo, należy postępować ściśle według poniższych kroków:

1. Sklonować repozytorium.

2. Otworzyć nowy terminal w folderze "SZUM".

3. Nadać możliwość wykonywania skryptu powłoki przez wszystkich użytkowników przy pomocy komendy: 
`sudo chmod a+x gazebo_setup.sh`

4. Uruchomić skrypt konfiguracyjny środowiska symulacji robota, który automatycznie uruchomi ją przy pomocy komendy: `./gazebo_setup.sh`

5. Rozpocząć symulację poprzez kliknięcie w programie Gazebo przycisku "Play".

6. Otworzyć nowy terminal w katalogu "SZUM", w którym należy uruchomić skrypt "matlabbash.sh" komendą: 
`./matlabbash.sh`

7. Po uruchomieniu skryptu matlabbash.sh należy wybrać jedną z sekwencji, jaką ma wykonać robot, wpisując w terminalu jej numer. 

    Każda sekwencja posiada swój numer:

     - 0 reset pozycji robota do pozycji startowej
     - 1 ruch głową po okręgu
     - 2 imitacja ukłonu
     - 3 ruch torsu po elipsie
     - 4 znak "tak"
     - 5 znak "nie"
     - 6 jednoczesny ruch okrężny torsu i głowy robota
     - 7 zakreślanie głową znaku nieskończoności
     - 8 kreślenie głową "rybki"
     - 9 wyjście 
 

8. Po wybraniu numeru, zostanie uruchomiony program Matlab, a następnie robot wykona daną sekwencję.

9. Po wykonaniu żądanych ruchów robot oczekuje na wybór kolejnej sekwencji.

UWAGA! W celu uniknięcia upadków robota, zaleca się resetowanie położenia modelu w Gazebo za pomocą kombinacji klawiszy `CTRL+SHIFT+R`, po wykonaniu danej sekwencji.

UWAGA! W przypadku błędów/awarii, wyłączamy Gazebo, w katalogu SZUM usuwamy folder "catkin_ws" i ponownie uruchamiamy skrypt gazebo_setup.sh (należy ponowić czynności od punktu 4 włącznie).

UWAGA! W celu resetowania świata w Gazebo należy używać tylko i wyłącznie kombinacji klawiszy `CTRL+SHIFT+R`.
W przypadku użycia kombinacji `CTRL+R`, należy wyłączyć program Gazebo oraz terminal, przez który został włączony, usunąć folder "catkin_ws" z katalogu "SZUM", a następnie otworzyć nowy terminal w katalogu "SZUM" oraz uruchomić ponownie skrypt gazebo_setup.sh (należy ponowić czynności od punktu 4 włącznie).
```
