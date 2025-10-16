--天刑王 ブラック・ハイランダー
function c900000099.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	-- 添加一个持续生效的禁制效果
    local e1 = Effect.CreateEffect(c)
    -- 效果描述，会显示在游戏内
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    -- 使用 EFFECT_CANNOT_SPECIAL_SUMMON 来限制特殊召唤
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    -- 影响范围：对方场地区域
    e1:SetRange(LOCATION_MZONE)
    -- 指定目标为对方玩家
    e1:SetTargetRange(0, 1)
    -- 自定义目标过滤函数，只限制从额外卡组的特殊召唤
    e1:SetTarget(c900000099.splimit)
    c:RegisterEffect(e1)

	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75326861,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c900000099.target)
	e2:SetOperation(c900000099.operation)
	c:RegisterEffect(e2)
end

-- 目标过滤函数，判断特殊召唤是否来自额外卡组
function c900000099.splimit(e, c, sump, sumtype, sumpos, targetp, se)
    -- 检查召唤类型是否为从额外卡组特殊召唤
    -- 注意：sumtype 的特殊召唤类型中，SUMMON_TYPE_FUSION 为融合，SUMMON_TYPE_SYNCHRO 为同调，
    -- SUMMON_TYPE_XYZ 为超量，SUMMON_TYPE_PENDULUM 为灵摆，SUMMON_TYPE_LINK 为连接召唤等。
    -- 0x60 是一个常见的位掩码，用于检测是否来自额外卡组（包括融合、同调、超量等）
    if sumtype and sumtype & 0x60 > 0 then
        -- 返回true表示阻止此次特殊召唤
        return true
    end
    -- 对于其他不属于上述明确类型的特殊召唤（例如通过卡片效果从额外卡组特召），
    -- 可以通过检查卡的位置来源进行补充限制
    if c and c:IsLocation(LOCATION_EXTRA) and targetp == 1-e:GetHandlerPlayer() then
        return true
    end
    return false
end

function c900000099.filter(c)
	return c:GetEquipCount()>0
end
function c900000099.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c900000099.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c900000099.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c900000099.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local eqg=g:GetFirst():GetEquipGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eqg,eqg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,eqg:GetCount()*400)
end
function c900000099.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local eqg=tc:GetEquipGroup()
		if eqg:GetCount()>0 then
			local des=Duel.Destroy(eqg,REASON_EFFECT)
			Duel.Damage(1-tp,des*400,REASON_EFFECT)
		end
	end
end
