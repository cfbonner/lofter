const colors = require('tailwindcss/colors')
module.exports = {
  darkMode: 'class',
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex',
    "../deps/petal_components/**/*.*ex",  
  ],
  theme: {
    extend: {
      colors: {
	green: colors.emerald,
	gray: colors.stone,
	primary: colors.green,
      }
    },
  }
}
