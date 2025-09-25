-- 速攻魔法卡：陷阱奇袭
-- 效果：丢弃任意数量的卡，然后可以直接发动手牌中相应数量的陷阱卡
local s, id = GetID()

function s.initial_effect(c)
    -- 速攻魔法卡
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, tp, 0)
end

function s.trapfilter(c)
    return c:GetType() == TYPE_TRAP and c:IsSSetable(true)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    -- 让玩家选择丢弃的手牌数量
    local max = Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0)
    if max <= 0 then return end
    
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
    local dis = Duel.AnnounceNumber(tp, 1, 2, 3, 4, 5, 6, max)
    
    -- 丢弃指定数量的手牌
    local g = Duel.SelectMatchingCard(tp, Card.IsAbleToGrave, tp, LOCATION_HAND, 0, dis, dis, nil)
    if #g > 0 and Duel.SendtoGrave(g, REASON_EFFECT+REASON_DISCARD) > 0 then
        -- 检查手牌中是否有可发动的陷阱卡
        local tg = Duel.GetMatchingGroup(s.trapfilter, tp, LOCATION_HAND, 0, nil)
        local tg_count = math.min(#tg, dis)
        
        if tg_count > 0 then
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
            -- 选择要发动的陷阱卡
            local sg = tg:Select(tp, 1, tg_count, nil)
            Duel.ConfirmCards(1-tp, sg)
            
            -- 直接发动选择的陷阱卡
            local tc = sg:GetFirst()
            while tc do
                -- 将陷阱卡直接放置在场上（表侧表示）
                if Duel.SSet(tp, tc) then
                    -- 立即发动陷阱卡
                    local e1 = Effect.CreateEffect(e:GetHandler())
                    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                    e1:SetCode(EVENT_CHAIN_END)
                    e1:SetLabelObject(tc)
                    e1:SetOperation(s.actop)
                    e1:SetReset(RESET_PHASE+PHASE_END)
                    Duel.RegisterEffect(e1, tp)
                end
                tc = sg:GetNext()
            end
        end
    end
end

function s.actop(e, tp, eg, ep, ev, re, r, rp)
    local tc = e:GetLabelObject()
    if tc and tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() then
        -- 发动陷阱卡
        local tpe = tc:GetType()
        if bit.band(tpe, TYPE_FIELD) ~= 0 then
            -- 场地陷阱卡处理
            local of = Duel.GetFieldCard(1-tp, LOCATION_SZONE, 5)
            if of then
                Duel.Destroy(of, REASON_RULE)
            end
            of = Duel.GetFieldCard(tp, LOCATION_SZONE, 5)
            if of and Duel.Destroy(of, REASON_RULE) ~= 0 then
                Duel.MoveSequence(tc, 5)
            end
        end
        
        -- 处理陷阱卡的发动效果
        local te = tc:GetActivateEffect()
        if te then
            local cost = te:GetCost()
            local target = te:GetTarget()
            local operation = te:GetOperation()
            
            -- 处理cost
            if cost then
                cost(te, tp, eg, ep, ev, re, r, rp, 1)
            end
            
            -- 处理target
            if target then
                target(te, tp, eg, ep, ev, re, r, rp, 1)
            end
            
            -- 处理operation
            if operation then
                operation(te, tp, eg, ep, ev, re, r, rp)
            end
        end
        
        -- 通常陷阱卡在发动后送去墓地[4](@ref)
        if bit.band(tc:GetType(), TYPE_TRAP) == TYPE_TRAP and 
           bit.band(tc:GetType(), TYPE_CONTINUOUS) == 0 and
           bit.band(tc:GetType(), TYPE_COUNTER) == 0 then
            Duel.SendtoGrave(tc, REASON_EFFECT)
        end
    end
    e:Reset()
end
