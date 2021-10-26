clear;

// データ関連値
DATA_NUM = 100;
CLASS_NUM = 10;
DATA_NUM_PER_CLASS = 10;

// 特徴量選択
FEAT_1 = 3; // 分散:横
FEAT_2 = 4; // 分散:縦


function prot = prototype(class)
    prot = mean(class, 'r'); // 平均値
endfunction

function prot = prototype2(class)
    prot = median(class, 'r'); // 中央値
endfunction

function n = number(prots, p)
    n = -1;
    mind = %inf;

    for i = 1 : DATA_NUM_PER_CLASS
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
    // クラス毎に処理
    dbegin = DATA_NUM_PER_CLASS * (i - 1) + 1;
    dend = DATA_NUM_PER_CLASS * i;
    class = feats(dbegin:dend, :);

    // プロトタイプ算出
    if i == 1
        prots(1, :) = prototype2(class);
    else
        prots = cat(1, prots, prototype2(class));
    end
end

// 全データ評価
for i = 1 : DATA_NUM
    data = feats(i, :);
    disp('Data ' + string(i) + ' is ' + string(number(prots, data)));
end
