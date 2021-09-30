const defaultTheme = require("tailwindcss/defaultTheme")
const colors = require('tailwindcss/colors')

module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
  mode: "jit",
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js"
  ],
  theme: {
    extend: {
      colors: {
	green: colors.emerald,
	gray: colors.warmGray,
      }
    },
  },
  variants: {},
  plugins: [],
}
