#! usr/bin/env perl
use strict;
use warnings;
use Math::Round qw(:all);

my %Player = (
   HP  => 50,
   AMR => 0,
   PWR => 0,
   WPN => '',
);

my %Enemy = (
   HP  => 50,
   AMR => 5,
   PWR => 32,
   WPN => 'Bone',

);

my $refPlayer = \%Player;
my $refEnemy = \%Enemy;

print "You find an axe and a shield hanging on the wall to your left.\n";
print "A two-handed sword to your right.\n";
print "Will you take the [1]Axe or the [2]Sword?\n";                                                #25

while (my $wchoice = <>){ 
    chomp ($wchoice);
    if ($wchoice == 1 || 2) {
        process_choice ($wchoice,$refPlayer);
        last;
    }else {
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
    if ($pounce >= 6) {                                                                             #50
        print "The blow cleaves a skull in two.\n";
        print "An enemy steps forward...\n";
        process_battle ($refPlayer, $refEnemy);
        last;
        }else{
            print "They are ready for you\n";
            process_battle ($refPlayer, $refEnemy);
            #The branch that opens up my magic system will start here.
            last;
} 
}elsif ($attack == 2) {
    print "You sulk off into a dark hallway that continues on a slight incline.\n";
    last;
}else{
    print "Are you going to do this or what?\n";
    redo; 
}
}

sub process_choice {
   my ($wchoice) = $_[0];
   my ($RefPlayer) = $_[1] ;

   if ($wchoice == 1) {
        $RefPlayer->{WPN} = 'Axe';                                                                  #75
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
   }
 }
sub process_battle {
    my($RefPlayer) = $_[0];
    my($RefEnemy) = $_[1];
while ($RefEnemy->{HP} > 1) {
    print "WHAT WILL YOU DO?!\n";
    print "[1] ATTACK    [2] DEFEND\n";
    print "[3] MAGIC     [4] RUN\n";
    my $battleplan = <>;
    
    if ($battleplan == 1) {
        process_pturn ($RefPlayer, $RefEnemy);
        process_eturn ($RefPlayer, $RefEnemy);
        redo;
}   elsif ($battleplan == 2) {
        my $defendbegin = ($RefPlayer->{AMR} * 3);
        $RefPlayer->{AMR} = $defendbegin;
        process_eturn ($RefPlayer, $RefEnemy);
        my $defendend = ($RefPlayer->{AMR} / 3);
        $RefPlayer->{AMR} = $defendend;
        redo;
}   elsif ($battleplan == 3) {
        print "magic?\n";
        redo;
}   elsif ($battleplan ==4) {
        my $runchance = int(rand(3));
        if ($runchance == 2) {
            print "It seems that you lost them\n";
            last;
}       else {
            print "Not the best time for a workout, but let's see if helped at all\n";
            process_eturn ($RefPlayer, $RefEnemy);
            redo;
}}   else{
        print "You are wasting time...\n";
        redo;
}}}


sub process_pturn {
    my($RefPlayer) = $_[0];
    my($RefEnemy) = $_[1];
    my $dmg = (); #displayed damage




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
            my $temp = (20 / $dice);                                                                #125
            my $dmgtemp = ($RefPlayer->{PWR} / $temp) * ($RefEnemy->{AMR} * .1);
            $dmg = nearest(1, $dmgtemp);
        }
    }

    my $EHP = $RefEnemy->{HP};
    print "Your axe hit for $dmg Hitpoints.\n";
    $RefEnemy->{HP} = ( $EHP - $dmg );
    print "The enemy has $RefEnemy->{HP} Hitpoints\n";
    if ($RefEnemy->{HP} < 1) {
       process_win ($RefPlayer, $RefEnemy);
    }
    return;
}


sub process_eturn {

    my($RefPlayer) = $_[0];
    my($RefEnemy) = $_[1];
    my $etdmg = (); #displayed damage

    my $etdicetemp = int(rand(19)) + 1; # raw dice roll           
    print "$etdicetemp\n";
                                                                                                    #150
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
    if ($RefPlayer->{HP} < 1) {
       process_dead () ;                                                                            #175
    }
    return;
}


sub process_critmiss {

    my($RefPlayer)  = $_[0];
    my($RefEnemy) = $_[1];
    my $eroll = (); #raw roll
    my $secroll = (); #prevents 0    
    my $finaledmg = (); #displayed HP count
    my $edmg = (); #displayed damage count
    my $netdmg = (); # calculated damage. Most likely in Decimal form
    my $etemp = (); # decides power modifier. Will be 1-4.
    my $dmgmath = (); # for $netdmg

$eroll = (int(rand(20)) +1);
print "$eroll\n";
$secroll = nearest_ceil(5, $eroll);
$etemp = (20 / $secroll);
$netdmg = ($RefEnemy->{PWR} / $etemp) * ($RefPlayer->{AMR} * .1); 
$dmgmath = $netdmg / 2;
$edmg = nearest_ceil(1, $dmgmath);
                                                                                                    #200
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

sub process_Enemymiss {
    my($RefPlayer)  = $_[0];
    my($RefEnemy) = $_[1];
    my $eroll2 = (); #raw roll
    my $secroll2 = (); #prevents 0                                                                
    my $finalpdmg = (); #displayed HP count
    my $edmg2 = (); #displayed damage count
    my $netdmg2 = (); # calculated damage. Most likely in Decimal form
    my $etemp2 = (); # decides power modifier. Will be 1-4.
    my $dmgmath2 = (); # for $netdmg

$eroll2 = (int(rand(20)) +1);
print "$eroll2\n";
$secroll2 = nearest_ceil(5, $eroll2);                                                               #225
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
sub process_win {
    my($RefPlayer) = $_[0];
    my($RefEnemy) = $_[1];
    print "Its Dead\n";
 exit;
}

sub process_dead {
    print "Its Over\n";
    exit;                                                                                           #250
}



