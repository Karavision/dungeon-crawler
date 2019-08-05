var def;

var red = {
    atk: 4,
    chance: 2,
    type: 'fire',
    name: 'Red Stone',
    text: 'The red spills upon the target in viscous flame'
};

var blue = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Blue Stone',
    text: 'The cold turns the skin a shade of blue and white.'

};

var green = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Green Stone',
    text: 'The toxins create a green drowned in blackness'

};

var yellow = {
    atk: 4,
    chance: 4,
    type: 'fire',
    name: 'Yellow Stone',
    text: 'The shift in fortune is almost noticable to all'

};

const magicStones = {
    red,
    blue,
    green,
    yellow
};

 var round = 0;
/* I need to turn this into a constructor function.
This will allow me to reset the stats after each fight*/
/*
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
*/
function base_player () {
    this.hp = 25;
    this.amr = 0;
    this.pwr = 0;
    this.wpn = '';
    this.psn = 0; //poison effect counter
    this.luck = 0; //luck effect counter
    this.amrwdn = 0; //turn counter for frost effect
    this.red = 0; //colors are inventory. They keep -
    this.blue = 0; //-players limited to one stone.
    this.green = 0;
    this.yellow = 0;
    this.cast = 0; //used to determine is magic was used during magic subroutine
    this.prevamr = 0; //used to reset AMR after frost effect
    this.won = 0;
}

function create (){
player = new base_player();
return;
}

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
// *This is where the main code will reside


// *This begins the function definitions

function diceRoll(min, max) { //Handles all dice rolls.
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min; //The maximum is inclusive and the minimum is inclusive 
}

// My next step is to recreate the main battle functions
function battle(player, enemy) {
    round++;
    document.querySelector('mainText').text = ("Round" + " " + round);
    create();
    while (won == 0) {
        document.getElementById("bMenu").style.visibility = "visible";
        document.getElementById("bMenu").style.opacity = "1";
        document.getElementById('attack').onclick = bChoice(this.id, player, enemy);
        document.getElementById('defend').onclick = bChoice(this.id, player, enemy);
        document.getElementById('magic').onclick = bChoice(this.id, player, enemy);
    }
    if (won == 1) {
        return;
    }
}

function bChoice(clicked_id, player, enemy, def) { // calls the functions for the battle choices.
    var choiceBttn = clicked_id;
    document.getElementById("bMenu").style.visibility = "hidden";
    switch (choiceBttn) {
        case "attack":
            choiceBttn = "disable";
            pTurn(player, enemy);
            eTurn(player, enemy, magicStones);
            break;

        case "defend":
            choiceBttn = "disable";
            def = 1.2; // multiplyer for player amr.
            eTurn(player, enemy, def, magicStones);
            break;

        case "magic":
            if (player.red == 1) {
                playerMagic("red", enemy);
                player.red = 0;
                break;
            }
            if (player.blue == 1) {
                playerMagic("blue", enemy);
                player.blue = 0;
                break;
            }
            if (player.green == 1) {
                playerMagic("green", enemy);
                player.green = 0;
                break;
            }
            if (player.yellow == 1) {
                playerMagic("yellow", enemy);
                player.yellow = 0;
                break;
            }
    }
    return;
}

function pTurn(player, enemy) { // The Player turn function
    if (player.won == 1) {
        return;
    }
    var dmg;
    var tempRoll = diceRoll(1, 20);
    if (tempRoll == 20) { // Critical Hit.
        dmg = (player.pwr * 1.5);
    } else if (tempRoll <= 2) { // Critical Miss.
        player.hp = (player.hp - (enemy.pwr / 4));
    } else {
        tempRoll = diceRoll(1, 4);
        dmg = (Math.round(player.pwr / tempRoll) * (enemy.amr * .1));
    }
    enemy.hp = (enemy.hp - dmg);
    if (enemy.hp < 1) {
        win(enemy);
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
    } else if ((tempRoll > 13) && (tempRoll < 20)) {
        var stone = ((diceRoll(1, 5)) - 1);
        enemyMagic(stone, magicStones, player);
    } else if (tempRoll <= 2) { // Critical Miss.
        enemy.hp = (enemy.hp - (player.pwr / 4));
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

function enemyMagic(indx, magicStones, player) {
    var cast = magicStones[indx];
    var proc;
    document.querySelector("gameText").innerHTML = cast.text;
    hitEmote();
    player.hp = (player.hp - ((cast.atk * 1.5) - diceRoll(1, 3))); // base spell damage
    if (player.luck == 1) { // the luck effect causes all spells to proc, automatically
        proc = 2;
    } else {
        proc = diceRoll(1, cast.chance);
    }
    switch (cast) {
        case "red": // additional fire damage
            if (proc == 2) {
                player.hp = (player.hp - 8);
            } else {
                break;
            }
            case "blue": // shatters armor
                if (proc == 2) {
                    player.amr = 0;
                } else {
                    break;
                }
                case "green": // causes poison damage
                    if (proc == 2) {
                        player.psn = 1;
                    } else {
                        break;
                    }
                    case "yellow": // sets luck effect
                        if (proc == 2) {
                            player.luck = 1;
                        } else {
                            break;
                        }
    }
    return;
}

function playerMagic(indx, enemy) {
    var cast = magicStones[indx];
    var proc;
    document.querySelector("gameText").innerHTML = cast.text;
    hitEmote();
    enemy.hp = (enemy.hp - ((cast.atk * 1.5) - diceRoll(1, 3))); // base spell damage
    if (player.luck == 1) { // the luck effect causes all spells to proc, automatically
        proc = 2;
    } else {
        proc = diceRoll(1, cast.chance);
    }
    switch (cast) {
        case "red": // additional fire damage
            if (proc == 2) {
                enemy.hp = (enemy.hp - 8);
            } else {
                break;
            }
            case "blue": // shatters armor
                if (proc == 2) {
                    enemy.amr = 0;
                } else {
                    break;
                }
                case "green": // causes poison damage
                    if (proc == 2) {
                        enemy.psn = 1;
                    } else {
                        break;
                    }
                    case "yellow": // sets luck effect
                        if (proc == 2) {
                            enemy.luck = 1;
                        } else {
                            break;
                        }
    }
    return;
}

function win(enemy) {
    round = 0;
    player.won = 1; // will exit the battle loop.
}

function hitEmote() {

}

function lose() { // Will go back to the start of the game.


}