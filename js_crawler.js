var red = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Red Stone'
};

var blue = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Blue Stone'
};

var green = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Green Stone'
};

var yellow = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Yellow Stone'
};

const magicStones = {
    red,
    blue,
    green,
    yellow
};

var player = { //All of the player data
    hp: 25,
    amr: 0,
    pwr: 0,
    wpn: '',
    psn: 0, //poison effect counter
    luck: 0, //luck effect counter
    amrwdn: 0, //turn counter for frost effect
    red: 0, //colors are inventory. They keep -
    blue: 0, //-players limited to one stone.
    green: 0,
    yellow: 0,
    cast: 0, //used to determine is magic was used during magic subroutine
    prevamr: 0 //used to reset AMR after frost effect
};
var enemy = { //All of the enemy data
    hp: 25,
    amr: 5,
    pwr: 32,
    wpn: 'Bone',
    psn: 0, //poison effect counter
    luck: 6, //luck effect counter
    amrwdn: 0, //turn counter for frost effect
    red: 0, //colors are inventory. They keep -
    blue: 0, //-players limited to one stone.
    green: 0,
    yellow: 0,
    cast: 0, //used to determine is magic was used during magic subroutine
    prevamr: 5 //used to reset AMR after frost effect
};

function diceRoll(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min; //The maximum is inclusive and the minimum is inclusive 
  }

// My next step is to recreate the main battle functions
function pTurn(player, enemy) {
    var dmg;
    var tempRoll = diceRoll(1, 20);
    if (tempRoll == 20) {
        dmg = (player.pwr * 1.5);}
    else if (tempRoll <= 2) {
        critMiss(player, enemy);}
    else {
        tempRoll = diceRoll(1, 20);
        dmg = (Math.round(player.pwr / tempRoll) * (enemy.amr * .1));
    }
    enemy.hp = (enemy.hp - dmg);

    
    }
}

function critMiss(player, enemy) {


}