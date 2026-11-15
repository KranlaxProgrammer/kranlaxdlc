SMODS.Joker{
    key = "rose",
    config = { extra = { wilted = false, xmult_normal = 2, xmult_wilted = 0.75, money_loss = 5 } },
    pos = { x = 0, y = 0 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    set_ability = function(self, card, initial, delay_sprites)
        -- Sobrescribimos su cálculo de precio para que el valor de venta siempre sea 0
        local orig_set_cost = card.set_cost
        card.set_cost = function(this)
            orig_set_cost(this)
            this.sell_cost = 0
        end
        card:set_cost()
    end,

    loc_vars = function(self, info_queue, card)
        if card.ability.extra.wilted then
            return { key = 'j_kranlaxs_wiltedrose', vars = { card.ability.extra.xmult_wilted, card.ability.extra.money_loss } }
        else
            return { key = 'j_kranlaxs_rose', vars = { card.ability.extra.xmult_normal } }
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local current_xmult = card.ability.extra.wilted and card.ability.extra.xmult_wilted or card.ability.extra.xmult_normal
            if current_xmult ~= 1 then
                return {
                    message = "X" .. current_xmult,
                    Xmult_mod = current_xmult,
                    colour = G.C.RED
                }
            end
        end

        if context.selling_self then
            if card.ability.extra.wilted and not context.blueprint then
                ease_dollars(-card.ability.extra.money_loss)
                return {
                    message = "-$" .. card.ability.extra.money_loss,
                    colour = G.C.RED
                }
            end
        end
    end
}

if not SMODS.kranlaxs_rose_click_hook then
    local orig_card_click = Card.click
    function Card:click()
        if self.area == G.jokers and self.config.center.key == 'j_kranlaxs_rose' then
            if self.ability and self.ability.extra and not self.ability.extra.wilted then
                self.ability.extra.wilted = true
                if self.children.center then
                    self.children.center:set_sprite_pos({x = 1, y = 0}) 
                end
                play_sound('card1')
                self:juice_up()
            end
        end
        if orig_card_click then orig_card_click(self) end
    end
    SMODS.kranlaxs_rose_click_hook = true
end