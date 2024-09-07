

CREATE TABLE `cadastros`(
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(40) NOT NULL,
  `documento` VARCHAR(20) NOT NULL,
  `cep` VARCHAR(9) NOT NULL,
  `estado` VARCHAR(30) NOT NULL,
  `cidade` VARCHAR(40) NOT NULL,
  `endereco` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `cadastros_tags` (
  `cadastro_id` INT NOT NULL,
  `tag_id` INT NOT NULL,
  PRIMARY KEY (`cadastro_id`,`tag_id`),
  FOREIGN KEY (`cadastro_id`) REFERENCES `cadastros` (`id`),
  FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) 
);

CREATE TABLE `categorias` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`)
);


CREATE TABLE `lancamentos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('pagar','receber') NOT NULL,
  `status` ENUM('aberto','liquidado') NOT NULL,
  `descricao` VARCHAR(30),
  `valor` DECIMAL(10,2) NOT NULL,
  `valor_liquidado` DECIMAL(10,2),
  `vencimento` DATE DEFAULT NULL,
  `liquidacao` DATE DEFAULT NULL,
  `cadastro_id` INT DEFAULT NULL,
  `categoria_id` INT DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`cadastro_id`) REFERENCES `cadastros` (`id`),
  FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`)
);


