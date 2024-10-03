// callExternalの呼び出し間隔（秒数）
const interval = 12;


// ランキングに表示する上位ランカーの数
const top = 3;


// 名前と点数を表示するText View
const names = [$.subNode("Name_1"), $.subNode("Name_2"), $.subNode("Name_3")];
const scores = [$.subNode("Score_1"), $.subNode("Score_2"), $.subNode("Score_3")];


$.onStart(() => {
    // 現在のランキングを取得するため、recordsが空の状態でサーバーにアクセスする
    let request = {type: "rankingSample", records: [], top: top};
    $.callExternal(JSON.stringify(request), "syncRanking");


    // ランキングに新しく登録するレコードの配列
    $.state.records = [];


    // 前回のcallExternal呼び出しからの経過時間
    $.state.waitingTime = 0;
});


$.onUpdate(deltaTime => {
    let records = $.state.records;


    // 前回の呼び出しから一定以上の時間が経過していればcallExternalを呼び出す
    let waitingTime = $.state.waitingTime + deltaTime;
    if (waitingTime >= interval) {
        waitingTime = 0;


        // サーバーへのrequestとして「サーバーでの処理分岐用タグ」「追加するレコード」「表示する上位ランカーの数」を設定
        // requestをstringに変換したものをサーバーに送信
        let request = {type: "rankingSample", records: records, top: top};
        $.callExternal(JSON.stringify(request), "syncRanking");


        // サーバーに送信済みのレコード情報をクリア
        $.state.records = [];
    }
    $.state.waitingTime = waitingTime;
});


$.onInteract(player => {
    // 新しいレコードを追加
    // レコードとして「ユーザー名」「スコア」を記録
    let records = $.state.records;
    let record = {name: player.userDisplayName, score: $.getStateCompat("owner", "score", "integer")};
    records.push(record);
    $.state.records = records;
});


// callExternal実行後、サーバーからの応答を受け取ったときに呼び出される処理
$.onExternalCallEnd((response, meta, errorReason) =>
{
    // サーバーとの通信でエラーが発生した場合にその理由を表示
    if (response == null) {
        $.log("callExternal ERROR: " + errorReason);
        return;
    }


    // metaを照合して処理を分岐
    // metaの値はcallExternalの第2引数に渡したもの
    if (meta === "syncRanking") {
        // サーバーからのresponseのJSONをパース
        let parsedResponse = JSON.parse(response);
       
        // responseの情報でtextViewを更新
        for(let i = 0; i < top; i++)
        {
            names[i].setText(parsedResponse.rankers[i].name);
            scores[i].setText(parsedResponse.rankers[i].score);
        }
    }
});