const defaultTheme = require("tailwindcss/defaultTheme")
const colors = require('tailwindcss/colors')

module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true,
  },
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Source Sans Pro", ...defaultTheme.fontFamily.sans]
      },
      colors: {
	green: colors.emerald,
	gray: colors.warmGray,
      }
    },
  },
  variants: {},
  plugins: [],
}
