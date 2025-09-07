--降邪的時針
function c900000091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c900000091.target)
	e1:SetCondition(c900000091.spcon)
	e1:SetOperation(c900000091.activate)
	c:RegisterEffect(e1)
end

function c900000091.spcon(e,tp,eg,ep,ev,re,r,rp)

	return Duel.IsExistingMatchingCard(c900000091.thfilter1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(c900000091.thfilter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(c900000091.thfilter3,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil)
    and Duel.IsExistingMatchingCard(c900000091.thfilter4,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(c900000091.thfilter5,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(c900000091.thfilter6,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(c900000091.thfilter7,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(c900000091.thfilter8,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil)
end

function c900000091.thfilter1(c,e,tp)
	return c:IsCode(77238291)
end
function c900000091.thfilter2(c,e,tp)
	return c:IsCode(77238292)
end
function c900000091.thfilter3(c,e,tp)
	return c:IsCode(77238293)
end
function c900000091.thfilter4(c,e,tp)
	return c:IsCode(77238294)
end
function c900000091.thfilter5(c,e,tp)
	return c:IsCode(77238295)
end
function c900000091.thfilter6(c,e,tp)
	return c:IsCode(77238296)
end
function c900000091.thfilter7(c,e,tp)
	return c:IsCode(77238297)
end
function c900000091.thfilter8(c,e,tp)
	return c:IsCode(900000086)
end


function c900000091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c900000091.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c900000091.activate(e,tp,eg,ep,ev,re,r,rp)
	
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 2
		or Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) then
		return
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)

	local mg=Duel.GetMatchingGroup(c900000091.rmfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,nil)

	local t1=0
	local t2=0
	local t3=0
	local t4=0
	local t5=0
	local t6=0
	local t7=0
	local t8=0
	local tc=mg:GetFirst()
	while tc do
		if tc:IsCode(77238291) and t1==0 then
			t1=1
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		if tc:IsCode(77238292) and t2==0 then
			t2=1
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		if tc:IsCode(77238293) and t3==0 then
			t3=1
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		if tc:IsCode(77238294) and t4==0 then
			t4=1
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		if tc:IsCode(77238295) and t5==0 then
			t5=1
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		if tc:IsCode(77238296) and t6==0 then
			t6=1
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		if tc:IsCode(77238297) and t7==0 then
			t7=1
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		if tc:IsCode(900000086) and t8==0 then
			t8=1
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		tc=mg:GetNext()
	end


	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c900000091.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end

function c900000091.filter(c,e,tp)
	return c:IsCode(900000092)
end

