E createFromEntity<T, E>(T entity, E converted) {
  if (entity is E) return entity;

  return converted;
}
