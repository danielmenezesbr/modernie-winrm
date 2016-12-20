# modernie-winrm
This Vagrantfile is able to configure WinRM automatically. It was tested only Win7-IE11 box provider by [Microsoft](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/).

<a href='https://pledgie.com/campaigns/33109'><img alt='Click here to lend your support to: modernie-winrm and make a donation at pledgie.com !' src='https://pledgie.com/campaigns/33109.png?skin_name=chrome' border='0' ></a>

# Instalation
```
mkdir c:\mybox && cd c:\mybox
```

```
git clone https://github.com/danielmenezesbr/modernie-winrm.git .
```

Download [IE11-Win7 box](http://aka.ms/ie11.win7.vagrant) and unzip it into c:\mybox. If you have curl and [7z](http://www.7-zip.org), you can do:
```
curl -LOk http://aka.ms/ie11.win7.vagrant
```

```
7z e ie11.win7.vagrant
```



First time you need to execute "vagrant up" twice.
```
vagrant up && vagrant up
```
# Demo
[Show animated gif](https://github.com/danielmenezesbr/modernie-winrm/blob/master/docs/demo.gif?raw=true)

# Screenshots
Configuration changed after provisionion.

Network location type:

![](https://github.com/danielmenezesbr/modernie-winrm/blob/master/docs/network_category.png?raw=true)

Firewall status:

![](https://github.com/danielmenezesbr/modernie-winrm/blob/master/docs/firewall1.png?raw=true)

WinRM:

![](https://github.com/danielmenezesbr/modernie-winrm/blob/master/docs/firewall2.png?raw=true)
