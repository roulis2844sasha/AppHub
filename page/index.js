function save() {
	gad.done('save');
}
function swi(id,func) {
    if ($('#'+id).checked)
        $('#'+id).value = 1;
    else
        $('#'+id).value = 0;
	if (typeof func == 'function')
		func();
}
function main() {
	if (!gad.getSession('login') || !gad.getSession('password'))
        location.href = 'login.html';
	gad.load('../cgi-bin/load.sh','get',
		function(res) {
			if (!res) return false;
			console.log(res);
			res = JSON.parse(res);
			console.log(res);
		}
	);
	$('nav button#save').onclick = save;
}
