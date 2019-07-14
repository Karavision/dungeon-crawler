var red = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Red Stone',
}

var blue = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Blue Stone',
}

var green = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Green Stone',
}

var yellow = {
    atk: 4,
    chance: 3,
    type: 'fire',
    name: 'Yellow Stone',
}

const magicStones = {
    red,
    blue,
    green,
    yellow
}

var player = {            //All of the player data
    hp: 25,
    amr: 0,
    pwr: 0,
    wpn: '',
    psn: 0,       //poison effect counter 
    luck: 0,      //luck effect counter
    amrwdn: 0,    //turn counter for frost effect
    red: 0,       //colors are inventory. They keep players limited to one stone, each.
    blue: 0,
    green: 0,
    yellow: 0,
    cast: 0,     //used to determine is magic was used during magic subroutine
    prevamr: 0   //used to reset AMR after frost effect
};                                                                                                 #50
 
var enemy = {            //All of the player data
    hp: 25,
    amr: 5,
    pwr: 32,
    wpn: 'Bone',
    psn: 0,       //poison effect counter 
    luck: 6,      //luck effect counter
    amrwdn: 0,    //turn counter for frost effect
    red: 0,       //colors are inventory. They keep players limited to one stone, each.
    blue: 0,
    green: 0,
    yellow: 0,
    cast: 0,     //used to determine is magic was used during magic subroutine
    prevamr: 5   //used to reset AMR after frost effect
};                                                                                                 #50
