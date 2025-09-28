--千年神器的记忆石板
function c900000093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77238410,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c900000093.thtg)
	e2:SetOperation(c900000093.thop)
	c:RegisterEffect(e2)

	--win
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c900000093.operation)
	c:RegisterEffect(e3)

	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c900000093.descon2)
	c:RegisterEffect(e4)
end


function c900000093.thfilter(c)
	return c:IsType(TYPE_SPELL) and (c:IsSetCard(0xa201) or c:IsCode(900000090)) and c:IsAbleToHand()
end
function c900000093.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c900000093.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c900000093.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c900000093.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c900000093.filter(c)
	return c:IsCode(77238291,77238292,77238293,77238294,77238295,77238296,77238297)
end
function c900000093.check(g)
	local a1=false
	local a2=false
	local a3=false
	local a4=false
	local a5=false
	local a6=false
	local a7=false
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetCode()
		if code==77238291 then a1=true
		elseif code==77238292 then a2=true
		elseif code==77238293 then a3=true
		elseif code==77238294 then a4=true
		elseif code==77238295 then a5=true
		elseif code==77238296 then a6=true
		elseif code==77238297 then a7=true
		end
		tc=g:GetNext()
	end
	return a1 and a2 and a3 and a4 and a5 and a6 and a7
end
function c900000093.operation(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_EXODIA = 0x10
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(c900000093.filter,nil)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND):Filter(c900000093.filter,nil)
	local wtp=c900000093.check(g1)
	local wntp=c900000093.check(g2)
	if wtp and not wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.Win(tp,WIN_REASON_EXODIA)
	elseif not wtp and wntp then
		Duel.ConfirmCards(tp,g2)
		Duel.Win(1-tp,WIN_REASON_EXODIA)
	elseif wtp and wntp then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ConfirmCards(tp,g2)
		Duel.Win(PLAYER_NONE,WIN_REASON_EXODIA)
	end
end

function c900000093.descon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end