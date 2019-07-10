
use strict; #dmgtest.pl
use warnings;
use Math::Round qw(:all);

my %Player = (
   HP  => 100,
   AMR => 0,
   PWR => 0,
   WPN => '',
);

my %Enemy = (
   HP  => 100,
   AMR => 0,
   PWR => 0,
   WPN => '',

);

my $refPlayer = \%Player;
my $refEnemy = \%Enemy;

print "You find an axe and a shield hanging on the wall to your left.\n";
print "A two-handed sword to your right.\n";                                                       #Line 25
print "Will you take the [1]Axe or the [2]Sword?\n";

while (my $wchoice = <>) {
      chomp ($wchoice);
    if    (grep { $_ eq $wchoice } qw(1 2)) {
        process_choice ($wchoice,$refPlayer);
        print values %Player;
        print "\n";
        exit;
    }elsif (lc ($wchoice) eq 'q') {
        exit;
    }else {
        print "Don't be stupid!\n";
        print "Do you want the Axe or the Sword!?\n";
    }
}


my $wchoice = <STDIN>;

until(($wchoice == 1) or ($wchoice == 2)) {
    #print "Don't be stupid!\nDo you want the Axe or the Sword!?\n";
    #$wchoice = <STDIN>;
}
                                                                                                   #Line 50
sub process_choice {
   my ($wchoice) = $_[0];
   my ($RefPlayer) = $_[1] ;

   if ($wchoice == 1) {
        $RefPlayer->{WPN} = 'Axe';
        $RefPlayer->{PWR} = 24;
        $RefPlayer->{AMR} = 3;
        print "You can cut the world with this axe and deflect it's response with the shield\n";
        print "Every obstacle before you is a problem and I have just given you the answer\n";
        print "walk...\n";
   } else {
        $RefPlayer->{WPN} = 'Broadsword';
        $RefPlayer->{PWR} = 32;
        $RefPlayer->{AMR} = 1;
        print "You can't parry with this thing...\n";
        print "You also can't lift it one-handed\n";
        print "Fuck them up...\n";
   }
 }




sub process_pturn {                                                                                #Line 75
    my($RefPlayer) = $_[0];
    my($RefEnemy) = $_[1];
    my $dmg = (); #displayed damage


    my $dicetemp = int(rand(19)) + 1; # raw dice roll           
    print "$dicetemp\n";

    if ($dicetemp == 20) {       # Critical Hit chance
        $dmg = $RefPlayer->{PWR} * 1.5;
        print "CRITICAL HIT!!!\n";

    } elsif ($dicetemp <= 2) {
            process_critmiss ($RefPlayer,$RefEnemy);
            exit;
    } else {
            my $dice = nearest_ceil(5, $dicetemp);
            print "$dice\n";
        if ($dice < 5) {                     #prevents "0"
            $dice = 5;
        } else {
            my $temp = (20 / $dice);
            my $dmgtemp = ($RefPlayer->{PWR} / $temp) * ($RefEnemy->{AMR} * .1);
            $dmg = nearest(1, $dmgtemp);
        }                                                                                          #Line 100
    }

    my $EHP = $RefEnemy->{HP};
    print "Your axe hit for $dmg Hitpoints.\n";
    $RefEnemy->{HP} = ( $EHP - $dmg );
    print "The enemy has $RefEnemy->{HP} Hitpoints\n";
    if ($RefEnemy->{HP} < 1) {
       process_win ($RefPlayer, $RefEnemy);
    }
    exit;
}


sub process_eturn {

    my($RefPlayer) = $_[0];
    my($RefEnemy) = $_[1];
    my $etdmg = (); #displayed damage

    my $etdicetemp = int(rand(19)) + 1; # raw dice roll           
    print "$etdicetemp\n";

    if ($etdicetemp == 20) {       # Critical Hit chance
        $etdmg = $RefPlayer->{PWR} * 1.5;
        print "CRITICAL HIT!!!\n";                                                                 #Line 125

    } elsif ($etdicetemp <= 2) {
            process_critmiss ($RefPlayer,$RefEnemy);
            exit;
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
       process_dead () ;
    }
    exit;
}                                                                                                  #Line 150


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

print "Critical Miss!! During your wild swing, the enemy was able to strike!!\n";
print "You were hit for $edmg.\n";
$finaledmg = ($RefPlayer->{HP} - $edmg);                                                           #Line 175
$RefPlayer->{HP} = $finaledmg;
print "You now have $RefPlayer->{HP} Hitpoints\n";

if ($RefPlayer->{HP} < 1) {
    process_dead () ;
    }
}


sub process_win {
    my($RefPlayer) = $_[0];
    my($RefEnemy) = $_[1];

    print "Its Dead\n";
}

sub process_dead {
    print "Its Over\n";
}

sub process_Enemymiss {
    my($RefPlayer)  = $_[0];
    my($RefEnemy) = $_[1];
    my $eroll2 = (); #raw roll
    my $secroll2 = (); #prevents 0                                                                 #Line 200
    my $finalpdmg = (); #displayed HP count
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
    exit;
    }
} 
                                                                                                   #Line 225

sub process_battle {

    my($RefPlayer)  = $_[0];
    my($RefEnemy) = $_[1];

    print "There's only one way you're getting through this asshole...\n";
    until($RefEnemy->{HP} < 1) {
        process_pturn ($RefPlayer, $RefEnemy);
        process_eturn ($RefPlayer, $RefEnemy);
    }
}
