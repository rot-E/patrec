clear;

// データ関連値
DATA_NUM = 100;
CLASS_NUM = 10;
DATA_NUM_PER_CLASS = 10;

// 特徴量選択
FEAT_1 = 3; // 分散:横
FEAT_2 = 4; // 分散:縦


function i = argmaxP(feats, data)
    i = -1;
    iprob = 0;

    for k = 1 : CLASS_NUM
        // クラス毎に処理
        dbegin = DATA_NUM_PER_CLASS * (k - 1) + 1;
        dend = DATA_NUM_PER_CLASS * k;
        class = feats(dbegin:dend, :);

        // 平均算出
        avg = mean(class, 'r');

        // 分散算出
        avg_e = repmat(avg, size(class, 'r'), 1);
        var = sqrt(sum((class - avg_e).^2, 'r') / DATA_NUM_PER_CLASS);

        prob = 0;
        for d = 1 : 2 // 各次元の独立性を仮定
            P = DATA_NUM_PER_CLASS / DATA_NUM;
            p = 1/(sqrt(2 * %pi) * var(1, d)) * exp(-(data(1, d) - avg(1, d))^2/(2 * var(1, d)^2));
            prob = prob + p * P;
        end

        if iprob < prob then
            i = k - 1;
            iprob = prob;
        end
    end
endfunction


// 指定された特徴量読込
feats = strtod(read_csv('feat.csv', ','));
feats = feats(:, [FEAT_1, FEAT_2]);

// 全データ評価
cnt = 0;
for i = 1 : CLASS_NUM
    for j = 1 : DATA_NUM_PER_CLASS
        k = DATA_NUM_PER_CLASS * (i - 1) + j;
        data = feats(k, :);
        res = argmaxP(feats, data);
        if res ~= i - 1
            cnt = cnt + 1;
        end
        disp('Data ' + string(k) + ' is ' + string(res));
     end
end
disp((DATA_NUM - cnt) / DATA_NUM);
