
#!/usr/bin/env perl
use Math::Round qw(:all);
use strict;
use warnings;



my %Magicstones = (          #The magic stone attributes
    Red => {
        ATK => 4,
        Chance => 3,
        Type => 'Fire',
        Name => 'Red Stone',},

    Blue => {
        ATK => 2,
        Chance => 3,
        Type => 'Frost',
        Name => 'Blue Stone',},

    Green => {
        ATK => 1,
        Chance => 4,
        Type => 'Poison',                                                                          #25
        Name => 'Green Stone',},

    Yellow => {
        ATK => 0,
        Chance => 2,
        Type => 'Luck',
        Name => 'Yellow',},);

my $RefMagic = \%Magicstones;   #The Reference for the magic stone attributes

my %Player = (             #All of the player data
   HP  => 25,
   AMR => 0,
   PWR => 0,
   WPN => '',
   PSN => 0,       #poison effect counter 
   Luck => 0,      #luck effect counter
   AMRDWN => 0,    #turn counter for frost effect
   Red => 0,       #colors are inventory. They keep players limited to one stone, each.
   Blue => 0,
   Green => 0,
   Yellow => 0,
   Cast => 0,     #used to determine is magic was used during magic subroutine
   PrevAMR => 0   #used to reset AMR after frost effect
);                                                                                                 #50

my %Enemy = (                  #All of the enemy data
   HP  => 25,
   AMR => 5,
   PWR => 32,
   WPN => 'Bone',
   PSN => 0,         #poison effect counter
   Luck => 6,        #controls chance to use magic stones instead of attacking
   AMRDWN => 0,      #turn counter for frost effect
   PrevAMR => 5,     #used to reset AMR after frost effect
);

my $RefPlayer = \%Player;      #Player and Enemy References
my $RefEnemy = \%Enemy;

print "You find an axe and a shield hanging on the wall to your left.\n";
print "A two-handed sword to your right.\n";
print "Will you take the [1]Axe or the [2]Sword?\n";

while (my $wchoice = <>){ 
    chomp ($wchoice);
    if ($wchoice == 1 || 2) {
        process_choice ($wchoice,$RefPlayer);
        last;
    }else {                                                                                        #75
        print "Don't be stupid!\n";
        print "Do you want the Axe or the Sword!?\n";
        redo;
    }
}

print "As you step down the corridor, you can already hear the sounds of life.\n";
print "This is obviously a busy throughway as no one is making any effort to lower their voices.\n";
print "You understand their language but ignore what they are saying. You count two voices.\n";
print "Still moving, you approach a corner and see that they both have their backs too you.\n";
print "Will you attack? [1]Yes [2]No\n";

while (1) {

my $attack = <STDIN>;
if ($attack == 1) {
    my $pounce = int(rand(10));
    if ($pounce >= 6) {
        print "The blow cleaves a skull in two.\n";
        print "An enemy steps forward...\n";
        process_battle ($RefPlayer, $RefEnemy, $RefMagic);
        last;
        }else{
            print "They are ready for you\n";
           process_battle ($RefPlayer, $RefEnemy, $RefMagic);                                      #100
           process_battle ($RefPlayer, $RefEnemy, $RefMagic); }
print "Anyone watching that would have said that it was not a glorious fight.\n";
print "At what point did you start winning? Do you know?\n";
print "There's someone else out there...\n";                                                       
print "All you barely catch the grin before you are jumping away from glowing blue.\n";
my $magicevent = ();
$magicevent = int(rand(2));

if ($magicevent == 1) {
    print "The blast was as cold as it was hard.\n";
    print "It hurt.\n";
    my $magiceventcheck = ($RefPlayer->{HP} - 15);
    $RefPlayer->{HP} = $magiceventcheck;
    if ($RefPlayer->{HP} < 1) {
        process_dead ();
    }
   process_battle ($RefPlayer, $RefEnemy, $RefMagic);
   print "The small form sprawled out before you has spilled out his worldly possessions on the way down.\n";
   print "Two more of those stones lie before you. Still glowing blue. Take them.\n";
   $RefPlayer->{Red} = 1;
   $RefPlayer->{Blue} =1; }

print "Your eyes go to the glowing from your pocket\n";
print "This stone.\n";                                                                             
print "I can tell you that it can't hurt to try throwing it at somthing.\n";                        #125
print "Just remember how you came upon it as you drudge ahead to a small group of lights\n";
            last;
} 
elsif ($attack == 2) {
    print "You sulk off into a dark hallway that continues on a slight incline.\n";
    print "Sadly, that incline leads to a wall of solid rock.\n";
    print " On the way back down, you hear screaming and roaring. There are flashes of light.\n";
    print " You get back to the throughway in time to see a fast moving circle of red explode into flames.\n";
    print " You can't see what it hit, but you can hear.\n";
    print " The screams turn to moans which turn to gasps. It seems safe to go down there, now\n";
    print " The winner has cleared out. Somthing like a rock suddenly glows red.\n";
    print " It is warm and light. You notice the warmth as it settles into your pocket\n";
    print " There is light ahead. You cannot see the ground at the moment.\n";
    print " The glow from your pocket keeps you from tripping. You drudge ahead\n"; 
    $RefPlayer->{Red} = 1;
    last;
}else{
    print "Are you going to do this or what?\n";
    redo; 
}
}


#end intro to magic. Current end of program.
# Beginning of subroutines                                                                          150
########################################################################################################
sub process_magic {  #Magic junction point.

    ($RefPlayer)  = $_[0];
    ($RefEnemy) = $_[1];
    ($RefMagic) = $_[2];

        if ($RefPlayer->{Red} == 1) {
            process_fire ($RefPlayer, $RefEnemy, $RefMagic);
            $RefPlayer->{Cast} = 1;}
        if ($RefPlayer->{Blue}== 1) {
            process_frost ($RefPlayer, $RefEnemy,$RefMagic);
            $RefPlayer->{Cast} = 1;}
        if ($RefPlayer->{Green}== 1) {
            process_poison ($RefPlayer, $RefEnemy, $RefMagic);
            $RefPlayer->{Cast} = 1;}
        if ($RefPlayer->{Yellow}== 1) {
            process_luck ($RefPlayer, $RefEnemy, $RefMagic);
            $RefPlayer->{Cast} = 1;}
        if ($RefPlayer->{Cast} == 0){
         print "You lack stones.\n";                                                               
         return;}
     $RefPlayer->{Cast} = 0;
return;
}                                                                                                   #175



 sub process_fire {  # The fire stone subroutine. 4 base damage. chance for 15 fire damage.
    ($RefPlayer) = $_[0];
    ($RefEnemy) = $_[1];
    ($RefMagic) = $_[2];

    print "There was a thud and just a little blood";
    my $tempfire =($RefEnemy->{HP} - 4); # subtract 4 base damage from enemy HP
    $RefEnemy->{HP} = $tempfire; #set enemy HP to new post-damage amount
    my $fireroll = int(rand($RefMagic->{Red}{Chance})); #random roll for the proc
    if ($fireroll == 2) {
        print "You smell charred body\n";
        print "You did 15 damage";
        my $firedamage = ($RefEnemy->{HP} - 15);
        $RefEnemy->{HP} = $firedamage;
    if ($RefEnemy->{HP} < 1) {
        process win ();
    } 
return;}}                                                                                                                                         



                                                                                                    #200

sub process_frost {      # The frost subroutine. 4 base damage. chance to take enemy amr to 0 for 2 turns.
    ($RefPlayer) = $_[0];
    ($RefEnemy) = $_[1];
    ($RefMagic) = $_[2];

    my $tempfrost =($RefEnemy->{HP} - 4); # subtract 4 base damage from enemy HP
    $RefEnemy->{HP} = $tempfrost; #set enemy HP to new post-damage amount 
    my $frostroll = int(rand($RefMagic->{Blue}{Chance})); #random roll for the debuff
    if ($frostroll == 2) {
        print "The effect is somwewhere between a shatter and full on dissolving of rock and leather.\n";
        print "As the scraps hit the floor the vitals are exsposed.\n";
        $RefEnemy->{AMR} = 0;

    }
return; }


sub process_poison {       #The poison subroutine. 4 base damage. chance to poison the enemy in process_battle.
    ($RefPlayer) = $_[0];
    ($RefEnemy) = $_[1];                                                                         
    ($RefMagic) = $_[2];

    my $temppoison =($RefEnemy->{HP} - 4); # subtract 4 base damage from enemy HP
    $RefEnemy->{HP} = $temppoison;        #set enemy HP to new post-damage amount                                                          #225
    my $poisonroll = int(rand($RefMagic->{Green}{Chance})); #random roll for the debuff
    if ($poisonroll == 2) {
        my $PSNtemp = ($RefEnemy->{PSN} + 3);
        $RefEnemy->{PSN} = $PSNtemp;
        print "The skin darkens with sickness.\n";
    }
return;
}

sub process_luck {          #Luck subroutine. No base damage. Chance to increase other stone chances.
    ($RefPlayer) = $_[0];
    ($RefEnemy) = $_[1];
    ($RefMagic) = $_[2];

    print "It explodes into a cloud of dust halfway to your target.\n";
    my $luckroll = int(rand(2));
    if ($luckroll == 2) {
        $RefPlayer->{Luck}++;
        $RefPlayer->{Luck}++;
        $RefMagic->{Red}{Chance}--;
        $RefMagic->{Blue}{Chance}--;                                                                
        $RefMagic->{Green}{Chance}--;
}
return;
}                                                                                                   #250

sub process_emagic {  #enemy magic subroutine. chance to come here from process_eturn
    ($RefPlayer) = $_[0];
    ($RefEnemy) = $_[1];
    ($RefMagic) = $_[2];
     my $emagicroll = ();    
     my $emagicdwn = ();
    print "The enemy hurls a stone.\n";
    $emagicroll = int(rand(4));
    if ($emagicroll == 1) {
        $RefPlayer->{Red} = 1;
        print "You burn... 15 points damage.\n";
        my $emagicdmg = $RefPlayer->{HP} - 15;
        $RefPlayer->{HP}  = $emagicdmg;
return;
}   elsif ($emagicroll == 2) {
        $RefPlayer->{Blue} = 1;
        print "You feel lighter. More fragile.\n";
        $emagicdwn = $RefPlayer->{AMRDWN} + 2;
        $RefPlayer->{AMRDWN} = $emagicdwn;
        $RefPlayer->{AMR} = 0;                                                                      
return;
}   elsif ($emagicroll == 3) {
        $RefPlayer->{Green} = 1;
        print "You barely keep down the bile.\n";                                                   #275
        my $epsntemp = ($RefPlayer->{PSN} + 3);
        $RefPlayer->{PSN} = $epsntemp;
return;
}   else {
        $RefPlayer->{Yellow} = 1;
        print "The dust is worrisome...\n";
        $RefEnemy->{LUCK} = 2;
return;
}}






sub process_pturn {     # Player attack sequence
    ($RefPlayer) = $_[0];
    ($RefEnemy) = $_[1];
    my $dmg = (); #displayed damage

                                                                                                    #300


    my $dicetemp = int(rand(19)) + 1; # raw dice roll           

    if ($dicetemp == 20) {       # Critical Hit chance
        $dmg = $RefPlayer->{PWR} * 1.5;
        print "CRITICAL HIT!!!\n";

    } elsif ($dicetemp <= 2) {
            process_critmiss ($RefPlayer,$RefEnemy);
            return;
    } else {
            my $dice = nearest_ceil(5, $dicetemp);
        if ($dice < 5) {                     #prevents "0"
            $dice = 5;
        } else {
            my $temp = (20 / $dice);                                                                
            my $dmgtemp = ($RefPlayer->{PWR} / $temp) * ($RefEnemy->{AMR} * .1);
            $dmg = nearest(1, $dmgtemp);
        }
    }

    my $EHP = $RefEnemy->{HP};
    print "Your axe hit for $dmg Hitpoints.\n";
    $RefEnemy->{HP} = ( $EHP - $dmg );                                                              #325
    print "The enemy has $RefEnemy->{HP} Hitpoints\n";
    if ($RefEnemy->{HP} < 1) {
       process_win ($RefPlayer, $RefEnemy);
    }
    return;
}
sub process_battle {   #The main battle subroutine
    ($RefPlayer) = $_[0];
    ($RefEnemy) = $_[1];
    ($RefMagic) = $_[2];
    $RefPlayer->{PSN} = 0;
    $RefEnemy->{PSN} = 0;
    $RefPlayer->{Luck} = 0;
    $RefEnemy->{Luck} = 0;
    $RefPlayer->{HP} = 25;
    $RefEnemy->{HP} = 25;
    while ($RefEnemy->{HP} > 1) {
    if ($RefEnemy->{HP} < 1) {
    process_win ();
    return; }
        print "Player HP :  $RefPlayer->{HP}\n"; #HP Display. Once per turn.
        print "Enemy HP  :  $RefEnemy->{HP}\n";
# poison/luck/armor reduction checks
        if ($RefEnemy->{PSN} != 0) {  #enemy poison tick and counter
            print "The enemy pulses a sickly green and loses 6 health.\n";
            my $Epoisontick =($RefEnemy->{HP} - 6);
            $RefEnemy->{HP} = $Epoisontick;
        if ($RefEnemy->{HP} < 1) {                                                                  #350
            process_win ();
            return;
        }
        $RefEnemy->{PSN}--;
}
        if ($RefPlayer->{PSN} != 0) {  #player poison tick and counter
            print "Your blood burns as you take 6 damage from the poison.\n";
            my $poisontick =($RefPlayer->{HP} - 6);
            $RefPlayer->{HP} = $poisontick;
        if ($RefPlayer->{HP} < 1) {
            process_dead ();
}
        $RefPlayer->{PSN}--;
}
        if ($RefPlayer->{Luck} != 0) {   #player luck counter
            $RefPlayer->{Luck}--;
            if ($RefPlayer->{Luck} == 0) {
                $RefMagic->{Red}{Chance}++;
                $RefMagic->{Blue}{Chance}++;
                $RefMagic->{Green}{Chance}++;
}}
        if ($RefEnemy->{Luck} != 6) {    #enemy luck counter
            $RefEnemy->{Luck}++;

}
        if ($RefPlayer->{AMRDWN} != 0) {   #player armor reduction counter                          #375
            $RefPlayer->{AMRDWN}--;
            if ($RefPlayer->{AMRDWM} == 0) {
                $RefPlayer->{AMR} = $RefPlayer->{PrevAMR};
}}
        if ($RefEnemy->{AMRDWN} != 0) {   #enemy armor reduction counter
             $RefEnemy->{AMRDWN}--;
            if ($RefEnemy->{AMRDWM} == 0) {
                $RefEnemy->{AMR} = $RefEnemy->{PrevAMR};
}}
#main battle screen
        print "WHAT WILL YOU DO?!\n";
        print "[1] ATTACK    [2] DEFEND\n";
        print "[3] MAGIC     [4] RUN\n";
        my $battleplan = <>;

        if ($battleplan == 1) {     #attack
            process_pturn ($RefPlayer, $RefEnemy);
            if ($RefEnemy->{HP} < 1) {
                return;}
            process_eturn ($RefPlayer, $RefEnemy, $RefMagic);
            redo;
}       elsif ($battleplan == 2) {    #defend
            my $defendbegin = ($RefPlayer->{AMR} * 3);
            $RefPlayer->{AMR} = $defendbegin;
            process_eturn ($RefPlayer, $RefEnemy, $RefMagic);
            my $defendend = ($RefPlayer->{AMR} / 3);
            $RefPlayer->{AMR} = $defendend;                                                         #400
            redo;
}       elsif ($battleplan == 3) {    #magic Was never fully implemented.
            print "magic?\n";
            redo;
}       elsif ($battleplan ==4) {     #run
            my $runchance = int(rand(3));
            if ($runchance == 2) {
                print "It seems that you lost them\n";
                last;
}           else {
                print "Not the best time for a workout, but let's see if helped at all\n";
                process_eturn ($RefPlayer, $RefEnemy, $RefMagic);
                redo;
}}      else{    #any other entry
        print "You are wasting time...\n";
        redo;
}}
}
#end main battle screen
sub process_Enemymiss {   # Enemy critical miss 
    ($RefPlayer)  = $_[0];
    ($RefEnemy) = $_[1];
    my $eroll2 = (); #raw roll
    my $secroll2 = (); #prevents 0                                                                
    my $finalpdmg = (); #displayed HP count                                                         #425
    my $edmg2 = (); #displayed damage count
    my $netdmg2 = (); # calculated damage. Most likely in Decimal form
    my $etemp2 = (); # decides power modifier. Will be 1-4.
    my $dmgmath2 = (); # for $netdmg

$eroll2 = (int(rand(20)) +1);
print "$eroll2\n";
$secroll2 = nearest_ceil(5, $eroll2);                                                               
$etemp2 = (20 / $secroll2);
$netdmg2 = ($RefPlayer->{PWR} / $etemp2) * ($RefEnemy->{AMR} * .1); 
$dmgmath2 = $netdmg2 / 2;
$edmg2 = nearest_ceil(1, $dmgmath2);

print "The Enemy misses horribly\n";
print "You are able to strike for $edmg2 Hitpoints.\n";
$finalpdmg = ($RefEnemy->{HP} - $edmg2);
$RefEnemy->{HP} = $finalpdmg;
print "The Enemy now has $RefEnemy->{HP} Hitpoints\n";
if ($RefEnemy->{HP} < 1) { 
    process_win ($RefPlayer, $RefEnemy);
} else{
      return;
} }
sub process_win { #battle end
    ($RefPlayer) = $_[0];                                                                         #450
    ($RefEnemy) = $_[1];
    print "Its over.\n";
 return;
}

sub process_dead { # Game over
    print "Its Over\n";
    exit;                                                                                           
}   

 sub process_critmiss {  #Player critical miss

    ($RefPlayer)  = $_[0];
    ($RefEnemy) = $_[1];
    my $eroll = (); #raw roll
    my $secroll = (); #prevents 0    
    my $finaledmg = (); #displayed HP count
    my $edmg = (); #displayed damage count
    my $netdmg = (); # calculated damage. Most likely in Decimal form
    my $etemp = (); # decides power modifier. Will be 1-4.
    my $dmgmath = (); # for $netdmg

$eroll = (int(rand(20)) +1);
print "$eroll\n";
$secroll = nearest_ceil(5, $eroll);                                                                 #475
$etemp = (20 / $secroll);
$netdmg = ($RefEnemy->{PWR} / $etemp) * ($RefPlayer->{AMR} * .1);
$dmgmath = $netdmg / 2;
$edmg = nearest_ceil(1, $dmgmath);
                                                                                                   
print "Critical Miss!! During your wild swing, the enemy was able to strike!!\n";
print "You were hit for $edmg.\n";
$finaledmg = ($RefPlayer->{HP} - $edmg);
$RefPlayer->{HP} = $finaledmg;
print "You now have $RefPlayer->{HP} Hitpoints\n";
if ($RefPlayer->{HP} < 1) {
    process_dead () ;
} else {
    return;
}}


  sub process_eturn { #Enemy attack turn

    ($RefPlayer) = $_[0];
     ($RefEnemy) = $_[1];
    my $etdmg = (); #displayed damage

    my $etdicetemp = int(rand(19)) + 1; # raw dice roll           
    print "$etdicetemp\n";                                                                          #500
                                                                                                    
    if ($etdicetemp == 20) {       # Critical Hit chance
        $etdmg = $RefPlayer->{PWR} * 1.5;
        print "CRITICAL HIT!!!\n";

     } elsif ($etdicetemp <= 2) {
            process_critmiss ($RefPlayer,$RefEnemy);
            return;
    } else {
            my $etdice = nearest_ceil(5, $etdicetemp);
            print "$etdice\n";
        if ($etdice < 5) {                     #prevents "0"
            $etdice = 5;
        } else {
            my $ettemp = (20 / $etdice);
            my $etdmgtemp = ($RefEnemy->{PWR} / $ettemp) * ($RefPlayer->{AMR} * .1);
            $etdmg = nearest(1, $etdmgtemp);
        }
    }

    my $PHP = $RefPlayer->{HP};
    print "The Enemy hit for $etdmg Hitpoints.\n";
    $RefPlayer->{HP} = ( $PHP - $etdmg ); 
    print "You now have $RefPlayer->{HP} Hitpoints\n";
    if ($RefPlayer->{HP} < 1) {                                                                     #525
       process_dead () ;                                                                            
    }
    return;
}
sub process_choice {
   my($wchoice) = $_[0];
   ($RefPlayer) = $_[1] ;

   if ($wchoice == 1) {
        $RefPlayer->{WPN} = 'Axe';                                                                  
        $RefPlayer->{PWR} = 24;
        $RefPlayer->{AMR} = 3;
        print "You can cut the world with this axe and deflect it's response with the shield\n";
        print "Every obstacle before you is a problem and I have just given you the answer\n";
        print "walk...\n";
   } else {
        $RefPlayer->{WPN} = 'Broadsword';
        $RefPlayer->{PWR} = 28;
        $RefPlayer->{AMR} = 1;
        print "You can't parry with this thing...\n";
        print "You also can't lift it one-handed\n";
        print "Fuck them up...\n";
        return;
   }
 }                                                                                                  #550







