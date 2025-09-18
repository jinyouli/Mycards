-- 卡片ID定义，假设卡片密码为25041518（请根据实际修改）
local s, id = GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()

    -- 特殊召唤限制：只能通过"奇迹之方舟"特殊召唤
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(s.splimit)
    c:RegisterEffect(e0)
    
    -- 战斗破坏怪兽时造成伤害并回复
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_DAMAGE + CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetCondition(aux.bdogcon)
    e1:SetTarget(s.damtg)
    e1:SetOperation(s.damop)
    c:RegisterEffect(e1)
    
    -- 被破坏后特殊召唤并添加不能攻击效果
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1,id)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(s.sptg2)
    e2:SetOperation(s.spop2)
    c:RegisterEffect(e2)
end

-- 特殊召唤条件函数
function s.splimit(e, se, sp, st)
    return se and se:GetHandler():IsCode(900000096)
end

-- 战斗破坏效果的目标设置
function s.damtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    local tc = e:GetHandler():GetBattleTarget()
    local atk = tc:GetBaseAttack()
    if atk < 0 then atk = 0 end
    Duel.SetTargetPlayer(1 - tp)
    Duel.SetTargetParam(atk)
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, atk)
    Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, atk)
end

-- 战斗破坏效果的操作
function s.damop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    if Duel.Damage(p, d, REASON_EFFECT) > 0 then
        Duel.Recover(tp, d, REASON_EFFECT)
    end
end

-- 被破坏后的特殊召唤目标
function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

-- 被破坏后的特殊召唤操作
function s.spop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, true, true, POS_FACEUP) > 0 then
        -- 添加不能攻击的效果
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_OATH)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
end
