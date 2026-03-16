import Mathlib

def myEven (t : Int) : Prop := ∃(k : Int), t = 2 * k

#check left_distrib

example (m n : Int) : myEven m ∧ myEven n → myEven (m + n) := by
    rintro ⟨h1, h2⟩
    -- Supongamos que m y n son pares.
    obtain ⟨a, ha⟩ := h1
    obtain ⟨b, hb⟩ := h2
    -- Por definición, existen dos enteros a y b tales
    -- que m = 2a y n = 2b.
    have conclusion_m_plus_n_is_even : myEven (m + n) := by
    -- have es como crear una variable en programación de
    -- tipo, en este caso, myEven y lo que hay después es el
    -- contenido de esa variable.
        refine ⟨a + b, ?_⟩
        -- Dentro de la definición de myEven:
            -- t toma el valor de m + n
            -- k toma el valor de a + b
            -- ?_ es la demostración que aparece a continuación
        calc
            m + n = 2 * a + 2 * b := by rw [ha, hb]
            -- Sustituimos m y n por 2a y 2b.
            -- rw significa rewrite.
            _ = 2 * (a + b) := by rw [← left_distrib]
            -- Factorizamos el 2 utilizando la propiedad left_distrib de Lean 4.
            -- La flecha a la izquierda indica que se aplica el lado
            -- izquierdo de la igualdad de la propiedad.
    exact conclusion_m_plus_n_is_even
    -- exact es equivalente a return en programación. Si
    -- conclusion_plus_n_is_even es del mismo tipo que lo que hay
    -- después de "→", entonces la demostración es correcta.
