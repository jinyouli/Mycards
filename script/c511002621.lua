--Duelist Kingdom
--edited by GameMaster(GM)
function c511002621.initial_effect(c)

	-- 激活后留在场地区域
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72497366,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetCondition(c511002621.ntcon)
	c:RegisterEffect(e2)
	--cannot direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e3)
	--unaffectable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c511002621.ctcon2)
	c:RegisterEffect(e6)


	-- 效果3: 怪兽被效果破坏时，控制者受到一半攻击力伤害
    local e7 = Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DAMAGE)
    e7:SetType(EFFECT_TYPE_FIELD | EFFECT_TYPE_TRIGGER_F)  -- 触发类效果
    e7:SetCode(EVENT_DESTROYED)  -- 监听破坏事件
    e7:SetRange(LOCATION_FZONE)
    e7:SetCondition(c511002621.damcon)  -- 伤害触发条件
    e7:SetTarget(c511002621.damtg)
    e7:SetOperation(c511002621.damop)
    c:RegisterEffect(e7)

	--cannot attack
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e12:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e12:SetRange(LOCATION_FZONE)
	e12:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e12:SetCondition(c511002621.atkcon)
	e12:SetTarget(c511002621.atktg)
	c:RegisterEffect(e12)
	--check
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e13:SetCode(EVENT_ATTACK_ANNOUNCE)
	e13:SetRange(LOCATION_SZONE)
	e13:SetOperation(c511002621.checkop)
	e13:SetLabelObject(e2)
	c:RegisterEffect(e13)

end

function c511002621.ctcon2(e,re)
	return re:GetHandler()~=e:GetHandler()
end

function c511002621.ntcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

-- 效果3: 伤害触发条件（怪兽被效果破坏）
function c511002621.damcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(  -- 检查被破坏的怪兽
        function(c)
            -- 确认是被效果破坏（非战斗破坏），且攻击力大于0
            return c:IsReason(REASON_EFFECT) and c:GetBaseAttack() > 0
        end, 
        1,  -- 至少有一只满足条件
        nil
    )
end

-- 效果3: 伤害目标设置
function c511002621.damtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    Duel.SetTargetCard(eg)  -- 将被破坏的怪兽设为目标，用于后续获取攻击力
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, PLAYER_ALL, 0)
end

-- 效果3: 伤害处理操作
function c511002621.damop(e, tp, eg, ep, ev, re, r, rp)
    local g = eg:Filter(  -- 过滤出被效果破坏的怪兽
        function(c) 
            return c:IsReason(REASON_EFFECT) and c:GetBaseAttack() > 0 
        end, 
        nil
    )
    for tc in aux.Next(g) do
        local p = tc:GetPreviousControler()  -- 获取怪兽之前的控制者
        local dam = math.floor(tc:GetBaseAttack() / 2)  -- 计算一半攻击力的伤害
        if dam > 0 then
            Duel.Damage(p, dam, REASON_EFFECT)  -- 对控制者造成伤害
        end
    end
end

function c511002621.atkcon(e)
	return e:GetHandler():GetFlagEffect(30606547)~=0
end
function c511002621.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c511002621.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(30606547)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(30606547,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
