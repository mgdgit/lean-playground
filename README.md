# Manual de Lean 4 (con Mathlib)

Este README está pensado como **manual de consulta rápida** para trabajar con Lean.
Incluye:

- firmas de funciones y teoremas,
- keywords/tácticas comunes,
- shortcuts de símbolos,
- propiedades matemáticas útiles de suma, resta, multiplicación y división.

En las secciones de **firmas** y **keywords** encontrarás siempre dos enfoques:

- **Para programadores**
- **Para matemáticos**

---

## 1. Mapa mental de Lean en 30 segundos

- En Lean, una proposición es un tipo (`Prop`).
- Una demostración es un término de ese tipo.
- `def` define objetos/funciones.
- `theorem`/`lemma`/`example` construyen demostraciones.
- `by` abre modo táctico (paso a paso).

Ejemplo:

```lean
example (P Q : Prop) : P ∧ Q → Q ∧ P := by
  rintro ⟨hP, hQ⟩
  exact ⟨hQ, hP⟩
```

---

## 2. Firmas en Lean

### 2.1 Cómo leer una firma

Una firma como:

```lean
def f (x : α) (y : β) : γ := ...
```

se lee así:

- entradas: `x : α`, `y : β`
- salida: `γ`

También puede escribirse en forma flecha:

```lean
def f : α → β → γ := ...
```

Eso significa una función currificada: recibe `α`, luego `β`, y devuelve `γ`.

### 2.2 Firmas más usadas (doble explicación)

| Firma | Para programadores | Para matemáticos |
|---|---|---|
| `α → β` | Tipo de función de `α` a `β`. | Aplicación entre conjuntos/tipos: \(f : \alpha \to \beta\). |
| `def f (x : α) : β := ...` | Declaras función con parámetro nombrado. | Defines explícitamente una aplicación y su regla. |
| `def f : α → β := fun x => ...` | Forma lambda/anónima. | Definición por abstracción \(x \mapsto ...\). |
| `theorem t (h : P) : Q := ...` | Función que transforma evidencia `P` en evidencia `Q`. | Demostración de implicación \(P \Rightarrow Q\). |
| `theorem t : P ↔ Q := ...` | Devuelves una estructura con dos direcciones (`→` y `←`). | Equivalencia lógica \(P \Leftrightarrow Q\). |
| `theorem t : ∀ x : α, P x := ...` | Función dependiente: para cada `x`, produce prueba de `P x`. | Cuantificador universal. |
| `theorem t : ∃ x : α, P x := ...` | Construyes un witness y su prueba (`⟨x, hx⟩`). | Existencial: exhibir un testigo. |
| `def f {α : Type} (x : α) : α := x` | Parámetro implícito; Lean lo infiere. | Dominio implícito de la construcción. |
| `def f [Group α] (x : α) : α := ...` | Requiere interfaz/typeclass (`Group`) para usar operaciones. | Trabajas en una estructura algebraica dada (grupo). |
| `def f : (x : α) → β x := ...` | Tipo dependiente: el tipo de salida depende de `x`. | Familia de objetos indexada por `x`. |

### 2.3 Plantillas útiles

```lean
def nombreFuncion (x : A) (y : B) : C := by
  -- código o prueba
  ...
```

```lean
theorem nombreTeorema (h1 : P) (h2 : Q) : R := by
  -- demostración táctica
  ...
```

```lean
example (a b : ℤ) : a + b = b + a := by
  rw [add_comm]
```

### 2.4 Comandos para inspeccionar firmas

- `#check nombre` muestra la firma inferida.
- `#check (expresión)` muestra el tipo de la expresión.
- `#eval` evalúa computación (cuando aplica).

Ejemplo:

```lean
#check add_comm
#check sub_eq_add_neg
#check (fun x : Nat => x + 1)
```

---

## 3. Keywords y tácticas comunes

> Nota: varias de estas “keywords” son tácticas de modo `by`.

| Keyword | Firma/uso típico | Para programadores | Para matemáticos |
|---|---|---|---|
| `example` | `example (...) : ... := by ...` | Prueba rápida sin poner nombre global. | Ejemplo corto para checar una idea. |
| `def` | `def f ... := ...` | Crea una función/valor para reutilizar. | Define formalmente un objeto. |
| `theorem` / `lemma` | `theorem t ... : ... := by ...` | Guarda una prueba con nombre (`lemma` suele ser apoyo). | Enunciado demostrado para usar después. |
| `have` | `have h : P := by ...` | Guarda un paso intermedio con nombre. | Introduce una afirmación auxiliar. |
| `let` | `let x := ...` | Crea una variable temporal. | Fija un objeto local. |
| `intro` | `intro x` | Toma el siguiente argumento de la meta. | "Sea x..." / "supongamos...". |
| `rintro` | `rintro x ⟨hx, hy⟩` | `intro` + desempaque en una sola línea. | Introduce y descompone hipótesis al mismo tiempo. |
| `refine` | `refine ⟨w, ?_⟩` | Pones la forma de la respuesta y dejas huecos. | Fijas la estructura de la prueba y dejas submetas. |
| `exact` | `exact h` | Cierra la meta con algo que ya tiene el tipo correcto. | "Esto es exactamente lo que pedían". |
| `apply` | `apply h` | Usa un teorema y cambia la meta por sus requisitos. | Aplica una regla para reducir el objetivo. |
| `rw` | `rw [h]` o `rw [← h]` | Reemplaza usando una igualdad. | Sustitución de iguales por iguales. |
| `simp` | `simp` / `simp [defs]` | Limpia automáticamente lo obvio. | Simplifica pasos rutinarios. |
| `norm_num` | `norm_num` | Hace cuentas numéricas concretas automáticamente. | Resuelve aritmética directa. |
| `linarith` | `linarith` | Resuelve ecuaciones/desigualdades lineales. | Combina hipótesis lineales para cerrar la meta. |
| `nlinarith` | `nlinarith` | Como `linarith`, pero tolera términos no lineales básicos. | Muy útil con cuadrados y productos sencillos. |
| `ring` | `ring` | Reordena polinomios y verifica que ambos lados coinciden. | Prueba identidades polinómicas automáticamente. |
| `omega` | `omega` | Solver para aritmética lineal en `ℕ` y `ℤ`. | Decide metas tipo Presburger (sumas, órdenes, etc.). |
| `calc` | `calc ... = ... := ...` | Encadena transformaciones paso a paso. | Cadena de igualdades/implicaciones. |
| `constructor` | `constructor` | Si la meta es doble (`∧`, `↔`), la separa en partes. | Prueba cada componente por separado. |
| `left` / `right` | `left` o `right` | Elige qué lado probar en un `∨`. | Escoge la rama de la disyunción. |
| `cases` | `cases h with ...` | Divide por casos y abre cada caso. | Prueba por casos. |
| `rcases` | `rcases h with ⟨x, hx⟩` | Versión compacta de `cases` con patrones. | Desarma existenciales/conjunciones rápido. |
| `obtain` | `obtain ⟨x, hx⟩ := h` | Extrae datos de una hipótesis y les da nombre. | "De h obtenemos x tal que...". |
| `use` | `use w` | Da el witness/testigo para un `∃`. | Exhibe el elemento que prueba existencia. |
| `show` | `show T` | Cambia explícitamente a la forma de meta que quieres atacar. | Reescribe el objetivo en forma equivalente. |

### 3.1 Ejemplo corto con varias tácticas

```lean
import Mathlib

def myEven (t : Int) : Prop := ∃ k : Int, t = 2 * k

example (m n : Int) : myEven m ∧ myEven n → myEven (m + n) := by
  rintro ⟨hm, hn⟩
  obtain ⟨a, ha⟩ := hm
  obtain ⟨b, hb⟩ := hn
  refine ⟨a + b, ?_⟩
  calc
    m + n = 2 * a + 2 * b := by rw [ha, hb]
    _ = 2 * (a + b) := by rw [← left_distrib]
```

---

## 4. Shortcuts de símbolos (entrada Unicode en Lean)

En VS Code con Lean, escribe `\comando` y normalmente presiona `Tab` o `Space`.

| Escribes | Sale | Uso |
|---|---|---|
| `\l` o `\lambda` | `λ` | Funciones anónimas |
| `\fun` | `↦` | Notación de mapeo |
| `\forall` | `∀` | Cuantificador universal |
| `\exists` | `∃` | Cuantificador existencial |
| `\to` | `→` | Implicación / tipo función |
| `\mapsto` | `↦` | Mapeo explícito |
| `\and` | `∧` | Conjunción |
| `\or` | `∨` | Disyunción |
| `\not` | `¬` | Negación |
| `\iff` | `↔` | Equivalencia |
| `\in` | `∈` | Pertenencia |
| `\notin` | `∉` | No pertenencia |
| `\subseteq` | `⊆` | Subconjunto |
| `\subset` | `⊂` | Subconjunto estricto |
| `\empty` | `∅` | Conjunto vacío |
| `\cup` | `∪` | Unión |
| `\cap` | `∩` | Intersección |
| `\le` | `≤` | Menor o igual |
| `\ge` | `≥` | Mayor o igual |
| `\ne` | `≠` | Distinto |
| `\nat` | `ℕ` | Naturales |
| `\int` | `ℤ` | Enteros |
| `\rat` | `ℚ` | Racionales |
| `\real` | `ℝ` | Reales |
| `\times` | `×` | Producto cartesiano |
| `\cdot` | `·` | Punto medio/separador |
| `\sum` | `∑` | Sumatoria |
| `\prod` | `∏` | Productoria |
| `\alpha` | `α` | Letras griegas |
| `\beta` | `β` | Letras griegas |
| `\gamma` | `γ` | Letras griegas |

Consejo: si no recuerdas un símbolo, empieza por `\` y escribe una palabra parecida en inglés (`exists`, `forall`, `subset`, `lambda`, etc.).

---

## 5. Propiedades matemáticas en Lean

En esta sección, además de la propiedad matemática, incluyo nombres de teoremas útiles de Lean/Mathlib.

## 5.1 Suma (`+`)

| Propiedad | En Lean | Comentario |
|---|---|---|
| Conmutativa | `add_comm` | `a + b = b + a` |
| Asociativa | `add_assoc` | `(a + b) + c = a + (b + c)` |
| Neutro `0` | `zero_add`, `add_zero` | `0 + a = a` y `a + 0 = a` |
| Cancelación | `add_left_cancel`, `add_right_cancel` | Si sumas lo mismo en ambos lados, puedes cancelar |
| Inverso aditivo | `neg_add_cancel`, `add_neg_cancel` | `-a + a = 0`, `a + (-a) = 0` (en grupos aditivos) |

Ejemplo:

```lean
example (a b : Int) : a + b = b + a := by
  rw [add_comm]
```

## 5.2 Resta (`-`)

| Propiedad | En Lean | Comentario |
|---|---|---|
| Definición conceptual | `sub_eq_add_neg` | `a - b = a + (-b)` |
| Auto-resta | `sub_self` | `a - a = 0` |
| Deshacer resta/suma | `sub_add_cancel` | `a - b + b = a` |
| Deshacer suma/resta | `add_sub_cancel_right` | `a + b - b = a` |
| Criterio de cero | `sub_eq_zero` | `a - b = 0 ↔ a = b` |

Observaciones importantes:

- En general, la resta **no es conmutativa** (`a - b ≠ b - a`).
- En general, la resta **no es asociativa**.
- En `ℕ`, la resta es truncada en `0` (no hay negativos):  
  si `n ≤ m`, entonces `n - m = 0` (`Nat.sub_eq_zero_of_le`).

## 5.3 Multiplicación (`*`)

| Propiedad | En Lean | Comentario |
|---|---|---|
| Conmutativa | `mul_comm` | `a * b = b * a` (en estructuras conmutativas) |
| Asociativa | `mul_assoc` | `(a * b) * c = a * (b * c)` |
| Neutro `1` | `one_mul`, `mul_one` | `1 * a = a`, `a * 1 = a` |
| Absorbente `0` | `zero_mul`, `mul_zero` | `0 * a = 0`, `a * 0 = 0` |
| Distributiva | `mul_add`, `add_mul` | `a*(b+c)=a*b+a*c`, `(a+b)*c=a*c+b*c` |
| Cancelación no nula | `mul_left_cancel₀`, `mul_right_cancel₀` | Requiere hipótesis de no-cero |

Ejemplo:

```lean
example (a b c : Int) : a * (b + c) = a * b + a * c := by
  rw [mul_add]
```

## 5.4 División (`/`)

Aquí hay que distinguir contextos:

- En `ℚ`, `ℝ` y cuerpos/campos: división como multiplicación por inverso.
- En `ℕ`, `ℤ`: división entera (euclidiana), con comportamiento distinto.

| Propiedad | En Lean | Comentario |
|---|---|---|
| Definición conceptual | `div_eq_mul_inv` | `a / b = a * b⁻¹` |
| Neutro | `div_one` | `a / 1 = a` |
| Inverso de sí mismo | `div_self` | `a / a = 1` si `a ≠ 0` |
| Cero dividido | `zero_div` | `0 / a = 0` |
| Distribución sobre suma | `add_div`, `div_add_div_same` | `(a+b)/c = a/c + b/c` y viceversa |
| Reasociación útil | `mul_div_assoc` | `a * b / c = a * (b / c)` |
| Reordenamiento | `div_mul_eq_mul_div` | `a / b * c = a * c / b` (contexto conmutativo) |
| Cero en cociente | `div_eq_zero_iff` | `a / b = 0 ↔ a = 0 ∨ b = 0` |

Observaciones clave:

- La división **no es conmutativa** ni asociativa en general.
- En Lean, `/` es función total. Por ejemplo, en muchas estructuras `a / 0` está definido (vía `inv 0 = 0`), aunque matemáticamente se suele tratar como “no permitido”.
- Para `ℕ`, si `a < b`, entonces `a / b = 0` (`Nat.div_eq_of_lt`).
- Para `ℤ`, una versión útil es `Int.ediv_eq_zero_of_lt` con hipótesis de signo y orden.

## 5.5 Potencias y raíces

### 5.5.1 Potencias: nombres y teoremas útiles

| Propiedad (nombre matemático) | Fórmula | En Lean |
|---|---|---|
| Exponente cero | `a^0 = 1` | `pow_zero` |
| Exponente uno | `a^1 = a` | `pow_one` |
| Potencia de uno | `1^n = 1` | `one_pow` |
| Base cero con exponente positivo | `0^n = 0` (si `n ≠ 0`) | `zero_pow` |
| Producto de potencias de igual base | `a^(m+n) = a^m * a^n` | `pow_add` |
| Potencia de una potencia | `a^(m*n) = (a^m)^n` | `pow_mul` |
| Potencia de un producto | `(ab)^n = a^n b^n` | `mul_pow` |
| Potencia de un cociente | `(a/b)^n = a^n / b^n` | `div_pow` |
| Potencia de un inverso | `(a⁻¹)^n = (a^n)⁻¹` | `inv_pow` |
| Cuadrado como producto | `a^2 = a*a` | `sq` |
| Binomio al cuadrado | `(a+b)^2 = a^2 + 2ab + b^2` | `add_sq` |

### 5.5.2 Raíces cuadradas en `ℝ`

| Propiedad (nombre matemático) | Fórmula | En Lean |
|---|---|---|
| Cuadrado de la raíz | `(√x)^2 = x` con `0 ≤ x` | `Real.sq_sqrt` |
| Raíz del cuadrado (no negativo) | `√(x^2) = x` con `0 ≤ x` | `Real.sqrt_sq` |
| Raíz del cuadrado en general | `√(x^2) = |x|` | `Real.sqrt_sq_eq_abs` |
| Criterio de raíz nula | `√x = 0 ↔ x = 0` con `0 ≤ x` | `Real.sqrt_eq_zero` |
| Raíz de producto | `√(xy) = √x * √y` (con hipótesis) | `Real.sqrt_mul` |
| Raíz de cociente | `√(x/y) = √x / √y` (con hipótesis) | `Real.sqrt_div` |
| Raíz de inverso | `√(x⁻¹) = (√x)⁻¹` | `Real.sqrt_inv` |

### 5.5.3 Raíz entera en `ℕ` (`Nat.sqrt`)

| Propiedad | En Lean | Comentario |
|---|---|---|
| Definición de función | `Nat.sqrt` | Raíz entera (piso de la raíz real). |
| Raíz de cuadrado perfecto | `Nat.sqrt_eq`, `Nat.sqrt_eq'` | `(n*n).sqrt = n` y `(n^2).sqrt = n` |
| Cota inferior cuadrática | `Nat.le_sqrt` | `m ≤ sqrt n ↔ m*m ≤ n` |
| Cota superior cuadrática | `Nat.sqrt_le` | `sqrt n * sqrt n ≤ n` |
| Monotonía | `Nat.sqrt_le_sqrt` | Si `m ≤ n`, entonces `sqrt m ≤ sqrt n` |
| Positividad | `Nat.sqrt_pos` | `0 < sqrt n ↔ 0 < n` |
| Criterio de cero | `Nat.sqrt_eq_zero` | `sqrt n = 0 ↔ n = 0` |

### 5.5.4 Raíz n-ésima como potencia fraccional

En reales, una forma común de modelar raíz n-ésima es:

```lean
-- idea matemática: n√x = x^(1/n)
#check Real.rpow
#check Real.rpow_add
#check Real.rpow_mul
```

`Real.rpow` es la potencia real `x^y` (exponente real), útil para modelar raíces y exponenciales fraccionales.

---

## 6. Mini chuleta práctica (flujo mental)

Cuando leas o escribas una prueba en Lean:

1. Mira el objetivo actual.
2. Si el objetivo es una implicación, usa `intro`/`rintro`.
3. Si el objetivo es un existencial, usa `refine ⟨..., ?_⟩` o `use`.
4. Si tienes igualdades útiles, usa `rw`.
5. Si hay simplificaciones obvias, prueba `simp`.
6. Si necesitas un paso intermedio, crea `have`.
7. Cierra con `exact` cuando ya tengas justo el tipo del objetivo.

---

## 7. Errores comunes (y cómo leerlos)

- `type mismatch`: el término no tiene el tipo esperado.
- `unknown identifier`: nombre mal escrito o no importado.
- `tactic failed`: la táctica no aplica en ese objetivo.
- `unsolved goals`: quedó trabajo pendiente.

Estrategia práctica:

1. Revisa el objetivo y las hipótesis visibles.
2. Usa `#check` para confirmar firmas.
3. Reduce el problema con `have` y `calc` en pasos pequeños.

---

## 8. Cierre

Este manual está pensado para usarse como referencia diaria.
Si quieres ampliarlo, una buena siguiente sección sería:

- cuantificadores y lógica proposicional en profundidad,
- estructuras algebraicas (`Monoid`, `Ring`, `Field`),
- táctica `ring`, `linarith`, `nlinarith` con ejemplos.
