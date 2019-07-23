var def;

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
    prevamr: 0, //used to reset AMR after frost effect
    won: 0
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

function diceRoll(min, max) { //Handles all dice rolls.
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min; //The maximum is inclusive and the minimum is inclusive 
}

// My next step is to recreate the main battle functions
function battle(player, enemy, def) {
    while (won == 0) {
        document.getElementById("bMenu").style.visibility = "visible";
        document.getElementById("bMenu").style.opacity = "1";
        document.getElementById('attack').onclick = bChoice(this.id, player, enemy);
        document.getElementById('defend').onclick = bChoice(this.id, player, enemy);
        document.getElementById('magic').onclick = bChoice(this.id, player, enemy);
    }
    if (won == 1) {
        return;
    }}

function bChoice(clicked_id, player, enemy, def) { // calls the functions for the battle choices.
    var choiceBttn = clicked_id;
    document.getElementById("bMenu").style.visibility = "hidden";
    switch (choiceBttn) {
        case "attack":
            choiceBttn = "disable";
            pTurn(player, enemy);
            eTurn(player, enemy);
            break;

        case "defend":
            choiceBttn = "disable";
            def = 1.2;   // multiplyer for player amr.
            eTurn(player, enemy, def);
            break;
    }

    return;
}

function pTurn(player, enemy) {  // The Player turn function
    if (player.won == 1) {
        return;
    }
    var dmg;
    var tempRoll = diceRoll(1, 20);
    if (tempRoll == 20) {            // Critical Hit.
        dmg = (player.pwr * 1.5);
    } else if (tempRoll <= 2) {     // Critical Miss.
        critMiss(player, enemy);
    } else {
        tempRoll = diceRoll(1, 4);
        dmg = (Math.round(player.pwr / tempRoll) * (enemy.amr * .1));
    }
    enemy.hp = (enemy.hp - dmg);
    if (enemy.hp < 1) {
        win();
    }
    hitEmote();
    return;
}

function eTurn(player, enemy, def) { // The enemy turn function
    if (player.won == 1) {
        return;
    }
    var dmg;
    var tempRoll = diceRoll(1, 20);
    if (tempRoll == 20) {
        dmg = (enemy.pwr * 1.5);
    } else if (tempRoll <= 2) {
        critMiss(player, enemy);
    } else {
        tempRoll = diceRoll(1, 20);
        dmg = (Math.round(enemy.pwr / tempRoll) * ((player.amr * def) * .1));
    }
    player.hp = (player.hp - dmg);
    if (player.hp < 1) {
        lose();
    }
    def = 0;
    hitEmote();
    return;
}

function critMiss(player, enemy) { // I may need to create a property that denotes a crit miss.


}

function win() {
    player.won = 1; // will exit the battle loop.
}

function hitEmote() {


}

function lose() { // Will go back to the start of the game.


}