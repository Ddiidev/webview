module main

import ttytm.webview

fn main() {
    mut w := webview.create(debug: true)
    w.set_title('Navegador Webview')
    w.set_size(1024, 768, .@none)

    // Navega para qualquer site externo:
    w.navigate('https://www.google.com.br')

	

	// w.bind('my_v_func', my_v_func)

    w.run()
    w.destroy()
}

fn my_v_func(e &webview.Event) string {
    println('Hello from V from V!')
    e.eval("console.log('Hello from V from JS!');")
    str_arg := e.get_arg[string](0) or { '' } // Get string arg at index `0`
    return str_arg + ' Hello back from V!'
}