clear;

// データ関連値
DATA_NUM = 100;
CLASS_NUM = 10;
DATA_NUM_PER_CLASS = 10;
EVAL_SET_NUM = 1;

// 特徴量選択
FEAT_1 = 3; // 分散:横
FEAT_2 = 4; // 分散:縦


function prot = prototype(class)
    prot = mean(class, 'r'); // 平均値
endfunction

function n = number(prots, p)
    n = -1;
    mind = %inf;

    for i = 1 : CLASS_NUM
        x = prots(i, 1) - p(1, 1);
        y = prots(i, 2) - p(1, 2);
        d = sqrt(x^2 + y^2);

        if d < mind
            n = i - 1;
            mind = d;
        end
    end
endfunction


// 指定された特徴量読込
feats = strtod(read_csv('feat.csv', ','));
feats = feats(:, [FEAT_1, FEAT_2]);

prots(1, 2) = 0;
for i = 1 : CLASS_NUM
    //学習用クラス毎に処理
    dbegin = DATA_NUM_PER_CLASS * (i - 1) + 1;
    dend = DATA_NUM_PER_CLASS * i - 1;
    class = feats(dbegin:dend, :);

    // プロトタイプ算出
    if i == 1
        prots(1, :) = prototype(class);
    else
        prots = cat(1, prots, prototype(class));
    end
end

// 評価用データ評価
for j = 1 : CLASS_NUM
    for k = DATA_NUM_PER_CLASS - EVAL_SET_NUM + 1 : DATA_NUM_PER_CLASS
        i = k + 10 * (j - 1) - 1;
        data = feats(i, :);
        disp('Data ' + string(i) + ' is ' + string(number(prots, data)));
    end
end
