$.onInteract((e=>{const n=$.worldItemReference("QuizFlow");n?n.send("nextQuestion",0):$.log("No itemHandle found nearby."),$.log("PushnextQuestionButton")}));