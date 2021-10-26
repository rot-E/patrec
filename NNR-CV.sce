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

// 識別器生成
prots_avg = zeros(CLASS_NUM, 2);
for c = 1 : DATA_NUM
    prots = zeros(1, 2);
    for i = 1 : CLASS_NUM
        // クラス毎に処理
        dbegin = DATA_NUM_PER_CLASS * (i - 1) + 1;
        dend = DATA_NUM_PER_CLASS * i - 1;
        class = feats(dbegin:dend, :);
        if c == dbegin
            dbegin = DATA_NUM_PER_CLASS * (i - 1) + 2;
            class = feats(dbegin:dend, :);
        elseif c > dbegin && c < dend
            dbegin = DATA_NUM_PER_CLASS * (i - 1) + 1;
            class = feats(dbegin:c-1, :);
            dend = DATA_NUM_PER_CLASS * i - 1;
            class = cat(1, class, feats(c+1:dend, :));
        elseif c == dend
            dend = DATA_NUM_PER_CLASS * i - 2;
            class = feats(dbegin:dend, :);
        end

        // プロトタイプ算出
        if i == 1
            prots(1, :) = prototype(class);
        else
            prots = cat(1, prots, prototype(class));
        end
    end
    prots_avg = prots_avg + prots;
end
prots_avg = prots_avg / DATA_NUM;

// 全データ評価
for i = 1 : DATA_NUM
    data = feats(i, :);
    disp('Data ' + string(i) + ' is ' + string(number(prots_avg, data)));
end
