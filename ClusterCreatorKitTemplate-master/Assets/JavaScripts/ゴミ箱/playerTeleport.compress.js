$.onReceive(((e,o)=>{"playerSelected"===e&&function(e,o){let l="A"===o?"RoomA":"RoomB";$.sendSignalCompat("teleportPlayer",{playerId:e,room:l})}(o.playerId,o.choice)}));