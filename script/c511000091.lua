--Turn Jump
function c511000091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_START,TIMING_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetOperation(c511000091.operation)
	c:RegisterEffect(e1)
end
function c511000091.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct>=2 then
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tep==1-tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) then
			Duel.NegateEffect(ct-1)
		end
	end

	if Duel.GetTurnPlayer()==tp then 
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,4)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,4)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,2,2)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,2)
		Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,3)
		Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,3)
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,3,3)
		Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,3)
	elseif Duel.GetTurnPlayer()~=tp then
		Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,4)
		Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,4)
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,2,2)
		Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,2)
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,3)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,3)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,3,3)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,3)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END,6)
	Duel.RegisterEffect(e1,tp)
	local be=Effect.CreateEffect(e:GetHandler())
	be:SetType(EFFECT_TYPE_FIELD)
	be:SetCode(EFFECT_CANNOT_EP)
	be:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	be:SetTargetRange(1,1)
	be:SetReset(RESET_PHASE+PHASE_MAIN1,7)
	Duel.RegisterEffect(be,tp)
end