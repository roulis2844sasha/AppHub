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
			$('input#ssid').value = res['wifi']['wssid'];
			if (res['wifi']['onoff'] == 'on') {
				$('input#onoff').value = 1;
				$('input#onoff').checked = true;
			}else{
				$('input#onoff').value = 0;
				$('input#onoff').checked = false;
			}
			if (res['wifi']['wpass']) {
				$('input#wpa').value = 1;
				$('input#wpa').checked = true;
				$('input#wpa_passphrase').value = res['wifi']['wpass'];
			}else{
				$('input#wpa').value = 0;
				$('input#wpa').checked = false;
			}
				
		}
	);
	$('nav button#save').onclick = save;
}
