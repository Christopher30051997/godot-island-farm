# 🏝️ Godot Island Farm - Low-Poly 3D

Un mapa de isla 3D low-poly completamente procedural para Godot Engine, con terreno aleatorio, animales, plantas, frutas, bosque, río y pantano. ¡Incluye un personaje jugable para explorar!

## 📋 Características

✨ **Isla Procedural Aleatoria**
- Tamaño variable entre 100-300 unidades
- Forma irregular única cada vez que se genera
- Terreno con césped y arena en los bordes

🌊 **Elementos de Agua**
- Río sinuoso que atraviesa la isla
- Pantano con múltiples zonas pantanosas
- Físicas estáticas para colisiones

🌳 **Vegetación**
- Árboles con troncos y follaje low-poly
- Arbustos decorativos
- Plantas variadas distribuidas naturalmente
- Frutas y rocas esparcidas

🐄 **Animales**
- Vacas (color marrón)
- Ovejas (color blanco)
- Cabras (color gris)
- Generados proceduralmente en la isla

👤 **Personaje Jugable**
- Modelo 3D bajo-poly
- Movimiento suave con gravedad
- Cámara que sigue al personaje
- Soporte para controles de teclado y táctiles

🎮 **Optimización**
- Polígonos entre 1000-2500
- Materiales naturales (colores realistas)
- Físicas estáticas donde es necesario
- Optimizado para móvil

## 🎮 Controles

### En PC (Teclado)
- **↑ ↓ ← →** - Mover personaje
- **Espacio** - Saltar
- **Rueda del ratón** - Zoom cámara
- **Click derecho + Movimiento** - Rotar cámara

### En Móvil (Táctil)
- **Desliza 1 dedo** - Rota la cámara
- **Pellizco (2 dedos)** - Zoom in/out
- **Botones virtuales** - Movimiento del personaje (se mostrarán en pantalla)

## 📂 Estructura del Proyecto

```
godot-island-farm/
├── project.godot
├── res://
│   ├── maps/
│   │   └── island_farm.tscn       # Escena principal de la isla
│   ├── scripts/
│   │   ├── island_generator.gd    # Generador procedural de la isla
│   │   └── player.gd              # Script del personaje jugable
│   └── README.md
```

## 🚀 Cómo Usar

### Opción 1: En Godot Engine (Recomendado para móvil)

1. **Descarga Godot Engine en tu celular** (gratuito desde PlayStore o AppStore)

2. **Clona o descarga el repositorio:**
   ```bash
   git clone https://github.com/Christopher30051997/godot-island-farm.git
   ```

3. **Abre Godot Engine en tu celular**

4. **Importa el proyecto:**
   - Selecciona "Open Project"
   - Navega a la carpeta `godot-island-farm`
   - Haz clic en "Select Current Folder"

5. **Abre la escena:**
   - En el FileSystem, ve a `res://maps/`
   - Haz doble clic en `island_farm.tscn`

6. **¡Presiona Play (▶) para comenzar!**

### Opción 2: En Godot Editor (PC)

1. **Instala Godot Engine 4.0+**

2. **Clona el repositorio:**
   ```bash
   git clone https://github.com/Christopher30051997/godot-island-farm.git
   ```

3. **Abre el proyecto en Godot Editor**

4. **Abre `res://maps/island_farm.tscn`**

5. **Presiona F5 para ejecutar**

### Opción 3: Exportar a APK (Android)

1. En Godot Editor:
   - Ve a **Project → Project Settings → Export**
   - Selecciona **Android**
   - Configura los permisos necesarios
   - Haz clic en **Export** y guarda como `.apk`

2. Transfiere el archivo a tu Android

3. Abre e instala el APK

## 🎨 Elementos del Mapa

| Elemento | Polígonos | Color | Descripción |
|----------|-----------|-------|------------|
| Terreno | ~100-150 | Verde cesped | Isla principal con forma irregular |
| Arena | ~50 | Beige | Borde arenoso de la isla |
| Río | ~30-50 | Azul claro | Flujo sinuoso de agua |
| Pantano | ~40-60 | Verde oscuro | Zonas pantanosas en la isla |
| Árbol (c/u) | ~44 | Marrón/Verde | Tronco + follaje esférico |
| Arbusto (c/u) | ~18 | Verde | Esfera de follaje |
| Animal (c/u) | ~20 | Vario | Cuerpo + cabeza |
| Planta (c/u) | ~1-3 | Verde claro | Plantas pequeñas |
| Fruta (c/u) | ~8 | Rojo | Pequeñas esferas rojas |
| Roca (c/u) | ~8 | Gris | Rocas distribuidas |

**Total aproximado: 1500-2500 polígonos**

## 🛠️ Personalizacion

### Cambiar el tamaño de la isla
En `res://scripts/island_generator.gd`, línea 5-7:
```gdscript
var island_size_min = 100  # Cambiar este valor
var island_size_max = 300  # Cambiar este valor
```

### Cambiar colores
En el mismo archivo, busca las secciones `StandardMaterial3D()` y cambia `albedo_color`:
```gdscript
material.albedo_color = Color(R, G, B, A)  # Valores entre 0 y 1
```

### Aumentar/disminuir cantidad de elementos
Busca las funciones como `generate_trees()`, `generate_animals()`, etc., y cambia los valores de `randi_range()`.

## 📊 Estadísticas

- **Tamaño de mapa:** 100-300 unidades (variable)
- **Polígonos totales:** 1000-2500
- **Elementos dinámicos:** 15-25 árboles, 10-20 arbustos, 20-40 plantas, 5-12 animales
- **Performance:** 60 FPS optimizado
- **Compatibilidad:** Godot 4.0+
- **Plataformas:** PC, Android, iOS, Web

## 🐛 Solución de Problemas

**La isla no se muestra:**
- Asegúrate de que la escena está en `res://maps/island_farm.tscn`
- Verifica que el script esté en `res://scripts/island_generator.gd`

**Los controles no funcionan en móvil:**
- Asegúrate de que estés usando Godot Engine en el celular
- Prueba primero en la configuración de entrada de Godot

**Baja performance:**
- Reduce `max_polys` en el script a 1500
- Disminuye la cantidad de árboles y animales

## 📝 Notas

- Cada vez que ejecutas el proyecto, la isla se genera **proceduralmente diferente**
- El personaje es totalmente jugable y puede explorar toda la isla
- Los animales están estáticos (se pueden agregar comportamientos IA después)
- El río y pantano no tienen agua que fluya (puramente visuales)

## 🎯 Futuras Mejoras

- [ ] Animaciones del personaje (caminar, correr, saltar)
- [ ] IA para los animales
- [ ] Animaciones de agua para río y pantano
- [ ] Sistema de recolección de frutas
- [ ] Sonidos ambientales
- [ ] Día/Noche cíclico
- [ ] Lluvia y clima dinámico

## 📄 Licencia

Este proyecto es de uso libre. ¡Úsalo como quieras!

## 👨‍💻 Autor

Creado por **Christopher Miller** (@Christopher30051997)

---

**¿Te gustó? ¡Dale una ⭐ en GitHub!**

Para más información o sugerencias, abre un issue en el repositorio.

## 🔗 Enlaces

- [Godot Engine](https://godotengine.org/)
- [Documentación de Godot](https://docs.godotengine.org/)
- [GitHub Repository](https://github.com/Christopher30051997/godot-island-farm)
