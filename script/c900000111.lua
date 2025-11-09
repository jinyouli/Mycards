-- 青眼究极龙之墓
function c900000111.initial_effect(c)
    -- 特殊召唤效果：将对方场上所有怪兽送墓后特召到对方场上
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(c900000111.sptg)
    e1:SetOperation(c900000111.spop)
    c:RegisterEffect(e1)

    -- 攻击力动态变化
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SET_ATTACK_FINAL)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c900000111.atkcon)
    e3:SetValue(c900000111.atkval)
    c:RegisterEffect(e3)

    -- 不能攻击
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e4)

    -- 不能改变表示形式
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    c:RegisterEffect(e5)

    -- 不能作为解放
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetCode(EFFECT_UNRELEASABLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)

    -- 此卡不会被战斗破坏
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e8:SetValue(1)
    c:RegisterEffect(e8)

    -- 被破坏时给予3000点伤害
    local e9=Effect.CreateEffect(c)
    e9:SetCategory(CATEGORY_DAMAGE)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e9:SetCode(EVENT_DESTROYED)
    e9:SetCondition(c900000111.damcon)
    e9:SetTarget(c900000111.damtg)
    e9:SetOperation(c900000111.damop)
    c:RegisterEffect(e9)

    -- 不能作为链接素材
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetValue(1)
    c:RegisterEffect(e10)
end

-- 检查此卡是否在对方场上
function c900000111.atkcon(e)
    return e:GetHandler():GetControler()~=e:GetHandler():GetOwner()
end

-- 特殊召唤的发动条件判断
function c900000111.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
            and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD)>0
            and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

-- 特殊召唤的效果处理
function c900000111.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local og=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    if #og>0 then
        Duel.SendtoGrave(og,REASON_EFFECT)
    end
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD)>0 then
        Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
    end
end

-- 攻击力计算函数：初始攻击力 - 下降值（每回合1000）
function c900000111.atkval(e,c)
    local atk=4500
    local turn_count=Duel.GetTurnCount()
    local summon_turn=c:GetTurnID()
    if summon_turn==0 or summon_turn~=c:GetTurnID() then
        summon_turn=turn_count
    end
    local passed_turns = turn_count - summon_turn
    local final_atk = atk - (passed_turns * 1000)
    if final_atk < 0 then final_atk = 0 end
    return final_atk
end

-- 被破坏时给予伤害的发动条件
function c900000111.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)
end

function c900000111.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(3000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
end

function c900000111.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end