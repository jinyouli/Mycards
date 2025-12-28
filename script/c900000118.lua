--クロノダイバー・スタートアップ
function c900000118.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(900000118,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c900000118.target)
	e0:SetOperation(c900000118.activate)
	c:RegisterEffect(e0)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(900000118,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c900000118.mattg)
	e1:SetOperation(c900000118.matop)
	c:RegisterEffect(e1)
end
function c900000118.filter(c,e,tp)
	return c:IsSetCard(0x126) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c900000118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c900000118.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c900000118.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c900000118.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c900000118.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x126)
end
function c900000118.matfilter(c)
	return c:IsSetCard(0x126) and c:IsCanOverlay()
end
function c900000118.ccfilter(c)
	return bit.band(c:GetType(),0x7)
end
function c900000118.fselect(g)
	return g:GetClassCount(c900000118.ccfilter)==g:GetCount()
end
function c900000118.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c900000118.matfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c900000118.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c900000118.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and g:CheckSubGroup(c900000118.fselect,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c900000118.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c900000118.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c900000118.matfilter),tp,LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:SelectSubGroup(tp,c900000118.fselect,false,3,3)
		if sg and sg:GetCount()==3 then
			Duel.Overlay(tc,sg)
		end
	end
end
