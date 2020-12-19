-- Galeem, Lord of Light
-- Scripted by FunnyBones777
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.fusfilter1,s.fusfilter2,s.fusfilter3,s.fusfilter4)
	Pendulum.AddProcedure(c,false)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.limval)
	c:RegisterEffect(e1)
	--destroy drawn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ddcon)
	e2:SetTarget(s.ddtg)
	e2:SetOperation(s.ddop)
	c:RegisterEffect(e2)
	--destroy all
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	--Immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(s.tgvalue)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(aux.bdocon)
	e6:SetTarget(s.sptg)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(s.pencon)
	e7:SetTarget(s.pentg)
	e7:SetOperation(s.penop)
	c:RegisterEffect(e7)
end
s.miracle_synchro_fusion=true
function s.fusfilter1(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp) and c:IsType(TYPE_FUSION,fc,sumtype,tp)
end
function s.fusfilter2(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp) and c:IsType(TYPE_SYNCHRO,fc,sumtype,tp)
end
function s.fusfilter3(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp) and c:IsType(TYPE_XYZ,fc,sumtype,tp)
end
function s.fusfilter4(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp) and c:IsType(TYPE_PENDULUM,fc,sumtype,tp)
end
function s.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function s.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function s.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.ddfilter,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(s.ddfilter,nil,tp)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function s.spfilter(c,e,tp,rp)
	if c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,rp,nil,c)<=0 then return false end
	return c:IsAttribute(ATTRIBUTE_LIGHT,fc,sumtype,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return loc~=0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,rp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,rp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end