$.onInteract((e=>{let t=$.getItemsNear($.getPosition(),5);for(let o of t)o.send("loadQuestion",e),$.log("send!")}));