function c900000106.initial_effect(c)
    c:SetUniqueOnField(1,0,900000106)
    aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup,nil)
    
    -- 复制效果
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetOperation(c900000106.gainop)
    c:RegisterEffect(e1)
    
    -- 离开场时重置效果
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetOperation(c900000106.resetop)
    c:RegisterEffect(e2)
end

function c900000106.gainop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetEquipTarget()
    if not tc then return end
    
    if myTable == nil then
        myTable = {}
    end

    if cid == nil then
        cid=0
    end

    local loc=LOCATION_ONFIELD|LOCATION_GRAVE|LOCATION_DECK|LOCATION_HAND|LOCATION_EXTRA|LOCATION_REMOVED
    local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,loc,0,1,1,nil,TYPE_EFFECT)
    
    if #g>0 then
        local sc=g:GetFirst()
        local code=sc:GetOriginalCode()
        
        cid=tc:CopyEffect(code, RESET_EVENT+RESETS_STANDARD, 1) -- 使用标准重置事件
        table.insert(myTable, cid)

        -- 复制名字
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(sc:GetOriginalCode())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end

function c900000106.resetop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetFirstCardTarget()
    if tc and tc:IsLocation(LOCATION_MZONE) then

        -- 清除所有复制的名字效果
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        
        for i, effectid in ipairs(myTable) do
            tc:ResetEffect(effectid,RESET_COPY)
            -- tc:ResetEffect(RESET_DISABLE,RESET_EVENT)
        end
        myTable = {}
    end
end